# Collect details of the application using SQL Tuning Sets

## Introduction

This lab walks you through the steps to create the sample tables and generate some simulated workload that we can use as the inputs for the rest of this workshop.

Estimated Lab Time: 10 minutes

### About SQL Tuning Sets

### Objectives

In this lab, you will:
* Create a set of application tables
* Create an SQL Tuning Set
* Simulate workload running against the application tables
* Load the workload data into the SQL Tuning Set

### Prerequisites (Optional)

This lab assumes you have:
* An Oracle account
* All previous labs successfully completed


## Task 1: Log in to the SQL Worksheet

When you ran the `setup.sh` script in the previous lab, it created a database user called `TKDRADATA` for you and granted that user the necessary permissions to complete the rest of the labs.

1. Navigate to the Details page of the Autonomous Database that was provisioned by the `setup.sh` script.  In this example, the database name is "DRADB."  Click **Database Actions**.

	![Image alt text](images/adb-main-page.png)

2. In the Development section of the Database Actions page, click the SQL card to open a new SQL worksheet:

  ![Image alt text](images/sql-card.png)

3. In the top right corner you can see that you are logged in as the `ADMIN` user.  We want to use the `TKDRADATA` user for the rest of this workshop.  Click on the `ADMIN` to open the user menu and select **Sign Out**.

  ![Image alt text](images/sign-out-from-admin.png)

4. On the next screen, click **Sign in**.

  ![Image alt text](images/click-sign-in.png)

5. Enter the username `TKDRADATA` and the password you defined when you ran the `setup.sh` script.

6. This will open a new SQL worksheet as the `TKDRADATA` user.

7. Enter your commands in the worksheet. You can use the shortcuts [Control-Enter] or [Command-Enter] to run the command and view the Query Result (tabular format). Clear your worksheet by clicking the trash:

    ![Image alt text](images/sql-worksheet.png)    


## Task 2: Prepare the application schema

1. Create the application tables by running this command.  You can just copy this and paste it into the SQL Worksheet and then hit the **Run Command** button.  You will do the same thing to run all of the other commands presented in this workshop.

    ```
    <copy>begin
        for i in 1..100 loop
            execute immediate
                'create table dra_' || i || '
                ( col' || i || ' varchar2(256) )
                ';
        end loop;
    end;
	
    /</copy>
    ```

    **Note**:  This command is provided in the file `create-tables.sql`.

2. You can validate the tables with this command, which should show you ten tables names `DRA_x` where `x` is a number:

    ```
    <copy>select table_name
    from user_tables
    fetch first 10 rows only;</copy>
    ```

## Task 3: Prepare the SQL Tuning Set

When you ran the `setup.sh` script in the previous lab, it created a database user called `TKDRADATA` for you and granted that user the necessary permissions to complete the rest of the labs.  We will create an SQL Tuning Set that we can use to capture details of the application workload.

1. Create a new SQL Tuning Set called `tkdradata` using the following command:

    ```
    <copy>begin
      dbms_sqltune.create_sqlset (
          sqlset_name => 'tkdradata', 
          description => 'SQL data from tkdradata schema'
      );
    end;
    /</copy>
    ```

    **Note**: This command is provided in the file `create-sts.sql`.

## Task 4: Simulate application workload

Now we will create some simulated application workload.  In a real-world scenario, you could actually capture real workload, perhaps for an extended period like two days or a week.  For the purposes of this lab, we will just simulate workload in a very short time so we can continue to the next steps.

1. Simulate workload by running the provided SQL script.  

    The file `simulate-workload.sql` contains about one hundred SQL commands.  Copy the contents of this file into you SQL Worksheet and click on the **Run script** button.  If you do not recall where the button is, please refer back to Task 1, Step 7 for a reminder.

## Task 5: Load the SQL Tuning Set

**Note**: The commands in this task **must** be run as the `ADMIN` user.  To open an SQL Worksheet for the `ADMIN` user, repeat steps 1 and 2 in Task 1.

1. Being careful to ensure you run this command as the `ADMIN` user, not `TKDRADATA`, load the workload data into the SQL Tuning Set using this command:

    ```
    -- run this as the ADMIN user
    <copy>DECLARE
      cur DBMS_SQLTUNE.SQLSET_CURSOR;
    BEGIN
      OPEN cur FOR
        SELECT VALUE(P)
          FROM table(
            DBMS_SQLTUNE.SELECT_CURSOR_CACHE(
              'parsing_schema_name=upper(''tkdradata'') and sql_text not like ''%OPT_DYN%''',
                NULL, NULL, NULL, NULL, 1, NULL,
              'ALL', 'NO_RECURSIVE_SQL')) P;
    
      DBMS_SQLTUNE.LOAD_SQLSET(sqlset_name => 'tkdradata',
                              populate_cursor => cur,
                              sqlset_owner => 'tkdradata');      
    END;
    / </copy>
    ```

    **Note**: This command is provided in the file `load-sts.sql`.

2. You can check that data was loaded using this command:

    ```
    <copy>select sqlset_name, count(distinct sql_id) 
    from dba_sqlset_plans 
    group by sqlset_name;</copy>
    ```

    This should return a non-zero value in the `tkdradata` row.  There may be other rows, but you can safely ignore them.  If you get zero, then please go back over the previous steps to make sure you did not miss a step.


Once this has been completed you are ready to **proceed to the next lab.**


## Learn More

## Acknowledgements
- **Author** - Mark Nelson, Developer Evangelist
- **Contributors** - Mark Nelson, Praveen Hiremath
- **Last Updated By/Date** - Praveen Hiremath, Developer Advocate, October 2022