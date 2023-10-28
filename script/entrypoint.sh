#!/bin/bash
set -e

# Check if requirements.txt file exists
if [ -f /opt/airflow/requirements.txt ]; then
  # Upgrade pip as the 'airflow' user
  su -c "pip install --upgrade pip" - airflow

  # Install Python packages from requirements.txt as the 'airflow' user
  su -c "pip install -r /opt/airflow/requirements.txt" - airflow
else
  # Create the requirements.txt file if it doesn't exist
  touch /opt/airflow/requirements.txt
  # Add your package requirements to the file
  echo "package_name==version" > /opt/airflow/requirements.txt

  # Now upgrade pip and install packages
  su -c "pip install --upgrade pip" - airflow
  su -c "pip install -r /opt/airflow/requirements.txt" - airflow
fi

# Check if airflow.db file does not exist
if [ ! -f /opt/airflow/airflow.db ]; then
  # Initialize the Airflow database as the 'airflow' user
  su -c "airflow db init" - airflow

  # Create an admin user (adjust the parameters as needed)
  su -c "airflow users create \
    --username admin \
    --firstname admin \
    --lastname admin \
    --role Admin \
    --email admin@example.com \
    --password admin" - airflow
fi

# Run the Airflow webserver as the 'airflow' user
su -c "airflow webserver" - airflow
