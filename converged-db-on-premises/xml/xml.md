# Oracle XML

## Introduction
This lab will cover three main topics. The Connect to SQL Developer Web will use SQL Developer Web, which is one of the tools that comes preinstalled with Autonomous Database. The Query XML Data uses XQuery which is a  general and expressive language, that combines the power of expression and computation with the strengths of SQL. The Insert and Update XML Data updates XML content or replaces either the entire contents of a document or only particular parts of a document.

*Estimated Lab Time*: 15 Minutes

### About Oracle XML
XML(Extensible Markup Language) is used to store and transport data. XML data is known as self-describing or self-defining, meaning that the structure of the data is embedded with the data, thus when the data arrives there is no need to pre-build the structure to store the data; it is dynamically understood within the XML.
The basic building block of an XML document is an element, defined by tags. An element has a beginning and an ending tag. All elements in an XML document are contained in an outermost element known as the root element.
XML can also support nested elements, or elements within elements. This ability allows XML to support hierarchical structures.

[](youtube:lGQvxPCYR2c)

For More Details About Oracle XML [Click here](#Appendix1:MoreaboutOracleXML)

### Objectives
In this lab, you will:
* Setup the environment for XML lab.
* Connect the oracle SQL developer to Insert and Update the XML Data into Oracle Database by using XML Function.
* Learn about the XML functions.


### Prerequisites
This lab assumes you have:
- A Free Tier, Paid or LiveLabs Oracle Cloud account
- You have completed:
    - Lab: Prepare Setup (*Free-tier* and *Paid Tenants* only)
    - Lab: Environment Setup
    - Lab: Initialize Environment

***Note:***  All scripts for this lab are stored in the **/u01/workshop/xml** folder and run as the oracle user.


## Task 1: Connect to the Pluggable Database (PDB)

<!-- 1. Open a terminal window and sudo to the user **oracle**

    ```
    <copy>
    sudo su - oracle
    </copy>
    ``` -->

1. Use a terminal window and navigate to the xml directory.

    ```
    <copy>
    cd /u01/workshop/xml
    </copy>
    ```

2. Set your environment.

    ```
    <copy>
    . oraenv
    </copy>
    ```

3. When prompted paste the following:

    ```
    <copy>
    convergedcdb
    </copy>
    ```

4. Open SQLPlus as the user appjson

    ```
    <copy>
    sqlplus appxml/Oracle_4U@JXLPDB
    </copy>
    ```
    ![](./images/xml_input2a.png " ")


## Task 2: Connect to SQL Developer

1. Make a connection to SQL Developer. Use the details as below and click on connect.

  - **Name**: XML
  - **Username**: appxml
  - **Password**: `Oracle_4U`
  - **Hostname**: localhost
  - **Port**: 1521
  - **Service name**: JXLPDB


    ![](./images/xml_sql_developer.png " ")

## Task 3: XML Query

1. Getting the number of XML documents.

    ```
    <copy>
    SELECT Count(*) FROM   purchaseorder p,  XMLTABLE('for $r in /PurchaseOrder return $r' passing object_value) t;
    </copy>
    ```

    ![](./images/xml_s3_p1.png " ")

2. Retrieving the content of an XML document-using pseudocolumn OBJECT_VALUE

    ```
    <copy>
      SELECT t.object_value.getclobval()FROM   purchaseorder t
      WHERE  rownum = 1;  
    </copy>
    ```

    ![](./images/xml_m2a.png " ")

3. Accessing text node value

    ```
    <copy>
    SELECT xmlcast(xmlquery('$p/PurchaseOrder/Reference/text()' passing object_value AS "p" returning content) AS varchar2(30))
    FROM   purchaseorder
    WHERe ROWNUM<= 5
    /
    </copy>
    ```

    ![](./images/xml_query_meth4a.png " ")


4. Searching XML document

    ```
    <copy>
     SELECT t.object_value.getclobval() FROM   purchaseorder t   WHERE  xmlexists('/PurchaseOrder[Reference/text()=$REFERENCE]' passing    object_value, 'AHUNOLD-20141130' AS "REFERENCE" )
         /
    </copy>
    ```

    ![](./images/xml_step3_search.png " ")

## Task 4: Insert XML record.

1. Let's take a count of the rows we have currently and then do a insert.

    ```
    <copy>
    select t.object_value.getclobval() from purchaseorder t;
     </copy>
     ```

     ![](./images/xml_s4_p1.png " ")


2. The insert query is available as a SQL file in the directory “**/u01/workshop/xml**”. The script is called as **insert.sql.** You can run this connecting to the SQL prompt.
3. Open a terminal window, execute the below command to insert.

    ```
    <copy>
    @insert.sql
    </copy>
    ```

    ![](./images/xml_input3a.png " ")

4. Verify XML record post insert

    ```
    <copy>select t.object_value.getclobval() from purchaseorder t;</copy>
    ```

    ![](./images/xml_s4_p3.png " ")

## Task 5: Update XML table

1. The update query is available as a sql file in the directory “**/u01/workshop/xml**”.
  The script is called as **update.sql**. You can run this connecting to the SQL prompt.

2. Open a terminal window, execute the below command to Update.

    <!-- ```
    <copy>
    . oraenv
    </copy>
    ```

    ```
    <copy>
    convergedcdb
    </copy>
    ```
    ```
    <copy>
    cd /u01/workshop/xml
    </copy>
    ```
    ```
    <copy>
    sqlplus appxml/Oracle_4U@JXLPDB
    </copy>
    ```

    ![](./images/xml_input2a.png " ") -->

    ```
    <copy>
    @update.sql
    </copy>
    ```

    ![](./images/xml_s5_p1.png " ")

3. Below is the select query to check if user is updated.

    ```
    <copy>
    SELECT extractValue(OBJECT_VALUE, '/PurchaseOrder/User') FROM purchaseorder WHERE existsNode(OBJECT_VALUE, '/PurchaseOrder[Reference="MSD-20200505"]') =1;
    </copy>
    ```

    ![](./images/xml_s5_p2.png " ")

4. Switch to terminal and exit from SQLPlus.

    ```
    <copy>
    exit
    </copy>
    ```

## Task 6: Example Queries

1. Get the list of the customer and their purchased information from a geo graphical location.  
    **XMLEXISTS** is an SQL/XML operator that you can use to query XML values in SQL, in a regular query I can use the xmlexists function to look if a specific value is present in an xmltype column.

    ```
    <copy>
      SELECT t.object_value.getclobval() FROM   purchaseorder t
      WHERE xmlexists('/PurchaseOrder/ShippingInstructions/Address[city/text()=$CITY]' passing object_value, 'South San Francisco' AS "CITY" );
    </copy>
    ```

    ![](./images/xml_s6_p1.png " ")

2. Customer purchase history  
    **XMLTABLE** converts XML Data into Rows and Columns using SQL. The XMLTABLE operator, which allows you to project columns on to XML data in an XMLTYPE , making it possible to query the data directly from SQL as if it were relational data.

    ```
    <copy>
      SELECT t.object_value.getclobval()
      FROM   purchaseorder p,
      XMLTABLE('for $r in /PurchaseOrder[Reference/text()=$REFERENCE] return $r' passing object_value, 'AHUNOLD-20141130' AS  "REFERENCE") t;  
    </copy>
    ```

    ![](./images/xml_step_6_q2.png " ")

3. Listing the product description those unit price matches to ‘$xx’.  
    **XMLSERIALIZE** is a SQL/XML operator that you can use to convert an XML type to a character type.

    ```
    <copy>
      SELECT XMLSERIALIZE(CONTENT COLUMN_VALUE AS CLOB INDENT SIZE=2)
      FROM  Purchaseorder p,
        XMLTable(
          '&lt;Summary&gt;
           {
            for $r in /PurchaseOrder/LineItems/Part
            return $r/Description
           }
           &lt;/Summary&gt;'
           passing object_value
        )
        WHERE xmlexists('/PurchaseOrder/LineItems/Part[UnitPrice/text()=$UnitPrice]' passing object_value, '27.95' AS "UnitPrice" );
    </copy>
    ```

    ![](./images/xml_s6_p3.png " ")

4. Customer order summary – Cost center wise.  
    **XMLQUERY** lets you query XML data in SQL statements. It takes an XQuery expression as a string literal, an optional context item, and other bind variables and returns the result of evaluating the XQuery expression using these input values. XQuery string is a complete XQuery expression, including prolog.

    ```
    <copy>
      SELECT xmlquery(
          '&lt;POSummary lineItemCount="{count($XML/PurchaseOrder/LineItems/ItemNumber)}"&gt;{
             $XML/PurchaseOrder/User,
             $XML/PurchaseOrder/Requestor,
             $XML/PurchaseOrder/LineItems/LineItem[2]
           }
           &lt;/POSummary&gt;'
          passing object_value AS "XML"
          returning content
        ).getclobval() initial_state
        FROM  PURCHASEORDER
        WHERE xmlExists(
          '$XML/PurchaseOrder[CostCenter=$CS]'
           passing object_value AS "XML",
                   'A90' AS "CS"      )
                   /
    </copy>
    ```

    ![](./images/xml_m9a.png " ")

5. Next Day Air - Customer Delivery Priority Instruction for e.g Ex - Courier, Expidite, Surface Mail, Air Mail etc..  
    **ExistsNodechecks** if xpath-expression returns at least one XML element or text node. If so, `existsNode` returns 1, otherwise, it returns 0. `existsNode` should only be used in the where clause of the select statement.

    ```
    <copy>
      SELECT extractValue(OBJECT_VALUE, '/PurchaseOrder/Reference') "REFERENCE"
      FROM purchaseorder WHERE existsNode(OBJECT_VALUE, '/PurchaseOrder[Special_Instructions="Next Day Air"]')=1;
    </copy>
    ```

    ![](./images/xml_m10_gg.png " ")

6. Priority Overnight - Customer Delivery Priority Instruction for e.g Ex - Courier, Expidite, Surface Mail, Air Mail etc..  
    **ExistsNodechecks** if xpath-expression returns at least one XML element or text node. If so, `existsNode` returns 1, otherwise, it returns 0. `existsNode` should only be used in the where clause of the select statement.

    ```
    <copy>
      SELECT extractValue(OBJECT_VALUE, '/PurchaseOrder/Reference') "REFERENCE"
    FROM purchaseorder
    WHERE existsNode(OBJECT_VALUE, '/PurchaseOrder[Special_Instructions="Priority Overnight"]')=1;
    </copy>
    ```

    ![](./images/xml_m10_ba.png " ")

You may now [proceed to the next lab](#next).

## **Appendix 1**: More about Oracle XML
### **XML with Oracle Database**

- Oracle XML DB is a high-performance, native XML storage and retrieval technology that is delivered as a part of all versions of Oracle Database.
- Oracle XML DB also supports the SQL/XML standard, which allows SQL-centric development techniques to be used to publish XML directly from relational data stored in Oracle Database.
- XML is an extremely popular way to persist and exchange business critical information.

Oracle XML DB allows an organization to manage XML content in the same way that will manages traditional relational data. This allows organizations to save costs and improve return on investment by using a single platform to manage and secure all of their mission critical data. Oracle XML DB was first released with Oracle 9iR2, and it has been enhanced in each subsequent major release of the database.

For example, XML documents can be very simple, such as the following:
![](./images/xml_snapa.png " ")

## Learn More

- Oracle XML Documentation ([XML](https://docs.oracle.com/en/database/oracle/oracle-database/19/adxdb/index.html))

## Rate this Workshop
When you are finished don't forget to rate this workshop!  We rely on this feedback to help us improve and refine our LiveLabs catalog.  Follow the steps to submit your rating.

1.  Go back to your **workshop homepage** in LiveLabs by searching for your workshop and clicking the Launch button.
2.  Click on the **Brown Button** to re-access the workshop  

    ![](https://oracle-livelabs.github.io/common/labs/cloud-login/images/workshop-homepage-2.png " ")

3.  Click **Rate this workshop**

    ![](https://oracle-livelabs.github.io/common/labs/cloud-login/images/rate-this-workshop.png " ")

If you selected the **Green Button** for this workshop and still have an active reservation, you can also rate by going to My Reservations -> Launch Workshop.

## Acknowledgements
* **Authors** - Balasubramanian Ramamoorthy, Arvind Bhope
* **Contributors** - Laxmi Amarappanavar, Kanika Sharma, Venkata Bandaru, Ashish Kumar, Priya Dhuriya, Maniselvan K, Robert Ruppel, David Start, Rene Fontcha
* **Last Updated By/Date** - Rene Fontcha, LiveLabs Platform Lead, NA Technology, December 2020
