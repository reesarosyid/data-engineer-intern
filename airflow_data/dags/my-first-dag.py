from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta

# Fungsi sederhana yang akan dijalankan oleh task
def print_hello():
    print("Hello, Airflow!")

# Definisi DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2024, 2, 18),
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG(
    'my_first_dag',
    default_args=default_args,
    description='DAG pertama saya',
    schedule_interval='@daily',  # Jalan setiap hari
)

# Task pertama
task_hello = PythonOperator(
    task_id='hello_task',
    python_callable=print_hello,
    dag=dag,
)

task_hello  # Menjalankan task
