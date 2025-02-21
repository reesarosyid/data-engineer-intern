from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
import pandas as pd
import psycopg2
from sqlalchemy import create_engine

# Konfigurasi database PostgreSQL
DB_CONN_SC = "postgresql+psycopg2://airflow:airflow@postgres:5432/Sample"
DB_CONN_DS = "postgresql+psycopg2://airflow:airflow@postgres:5432/DWH"
CSV_FILE_PATH = "/opt/airflow/dags/dataset/transaction_csv.csv"
EXCEL_FILE_PATH = "/opt/airflow/dags/dataset/transaction_excel.xlsx"

# Fungsi Extract
def extract():
    # Extract dari PostgreSQL
    engine = create_engine(DB_CONN_SC)
    query_account = "SELECT * FROM _dbo_account"
    query_branch = "SELECT * FROM _dbo_branch"
    query_city = "SELECT * FROM _dbo_city"
    query_customer = "SELECT * FROM _dbo_customer"
    query_state = "SELECT * FROM _dbo_state"
    query_transaction = "SELECT * FROM _dbo_transaction_db"
    
    # Use pandas to run the queries and read the results into DataFrames
    df_account = pd.read_sql_query(query_account, engine)
    df_branch = pd.read_sql_query(query_branch, engine)
    df_city = pd.read_sql_query(query_city, engine)
    df_customer = pd.read_sql_query(query_customer, engine)
    df_state = pd.read_sql_query(query_state, engine)
    df_transaction_db = pd.read_sql_query(query_transaction, engine)
    
    # Extract dari CSV
    df_transaction_csv  = pd.read_csv(CSV_FILE_PATH)
    
    # Extract dari Excel
    df_transaction_excel = pd.read_excel(EXCEL_FILE_PATH)
    
    return df_account, df_branch, df_city, df_customer, df_state, df_transaction_db, df_transaction_csv, df_transaction_excel


# Fungsi Transform
def transform(**kwargs):
    ti = kwargs['ti']
    df_account, df_branch, df_city, df_customer, df_state, df_transaction_db, df_transaction_csv, df_transaction_excel = ti.xcom_pull(task_ids='extract')
    
    # TRANSFORMATION
    ## DataDim
    ### DimCustomer
    DimCustomer = df_customer.merge(df_city, on='city_id', how='left')
    DimCustomer = DimCustomer.merge(df_state, on='state_id', how='left')
    DimCustomer.drop(['state_id', 'city_id'], axis=1, inplace=True)
    DimCustomer.columns = ['customerid', 'customername', 'address', 'age', 'gender', 'email', 'cityname', 'statename']
    DimCustomer["customername"] = DimCustomer["customername"].str.upper()
    DimCustomer["address"] = DimCustomer["address"].str.upper()
    DimCustomer["cityname"] = DimCustomer["cityname"].str.upper()
    DimCustomer["statename"] = DimCustomer["statename"].str.upper()
    DimCustomer["gender"] = DimCustomer["gender"].str.upper()
    DimCustomer["email"] = DimCustomer["email"].str.lower()
    DimCustomer = DimCustomer[["customerid", "customername", "address", "cityname", "age", "gender", "email"]]
    
    ### DimBranch
    DimBranch = df_branch
    DimBranch.columns = ['branchid', 'branchname', 'branchlocation']

    ### DimAccount
    DimAccount = df_account
    DimAccount.columns = ['accountid', 'customerid', 'accounttype', 'balance', 'dateopened', 'status']

    ## DataFact
    ### FactTransaction
    df_transaction_csv["transaction_date"] = pd.to_datetime(df_transaction_csv["transaction_date"], format="%d-%m-%Y %H:%M:%S")
    FactTransaction = pd.concat([df_transaction_db, df_transaction_excel, df_transaction_csv], ignore_index=True)
    FactTransaction = FactTransaction.drop_duplicates(subset=["transaction_id"], keep="first")
    FactTransaction.columns = ['transactionid', 'accountid', 'transactiondate', 'amount', 'transactiontype', 'branchid']
    FactTransaction = FactTransaction[['transactionid', 'accountid', 'branchid', 'transactiondate', 'amount', 'transactiontype']]
    # Convert transactiondate to string format
    FactTransaction["transactiondate"] = FactTransaction["transactiondate"].astype(str)
    
    return DimCustomer, DimBranch, DimAccount, FactTransaction

# Fungsi Load
def load(**kwargs):
    ti = kwargs['ti']
    DimCustomer, DimBranch, DimAccount, FactTransaction = ti.xcom_pull(task_ids='transform')
    
    engine = create_engine(DB_CONN_DS)

    # Load
    DimCustomer.to_sql("dimcustomer", engine, index=False, if_exists='append')
    DimBranch.to_sql("dimbranch", engine, index=False, if_exists='append')
    DimAccount.to_sql("dimaccount", engine, index=False, if_exists='append')
    FactTransaction.to_sql("facttransaction", engine, index=False, if_exists='append')

# Definisi DAG
default_args = {
    'owner': 'airflow',
    'start_date': datetime(2024, 1, 1),
    'retries': 1,
}

dag = DAG(
    'etl_to_DWH',
    default_args=default_args,
    schedule_interval='@daily',
    catchup=False
)

# Task-tasks dalam DAG
extract_task = PythonOperator(
    task_id='extract',
    python_callable=extract,
    dag=dag
)

transform_task = PythonOperator(
    task_id='transform',
    python_callable=transform,
    provide_context=True,
    dag=dag
)

load_task = PythonOperator(
    task_id='load',
    python_callable=load,
    provide_context=True,
    dag=dag
)

# Menentukan urutan eksekusi task
extract_task >> transform_task >> load_task
