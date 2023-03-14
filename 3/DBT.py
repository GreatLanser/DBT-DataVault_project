from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta

x = """dbt run --profiles-dir /mnt/c/users/vbassarab/.dbt \
--project-dir /mnt/c/users/vbassarab/Desktop/work_doc/Neostudy/DBT+DATA_VAULT/2.1/dbt_start
"""


with DAG(dag_id='dbt',
         start_date=datetime.now() - timedelta(days=1),
         schedule='@daily') as dag:
    dbt_run = BashOperator(
        task_id='dbt_run',
        owner='vbassarab',
        bash_command=x,
        dag=dag
    )

    dbt_run
