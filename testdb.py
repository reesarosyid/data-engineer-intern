import pg8000

conn = pg8000.connect(
    user="airflow",
    password="airflow",
    host="localhost",
    port=5432,
    database="airflow"
)

cursor = conn.cursor()
cursor.execute("SELECT version();")
print(cursor.fetchone())
cursor.close()
conn.close()
