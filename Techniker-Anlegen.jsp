<!doctype html>
<%@ page contentType="text/html" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<style>

    .center {
        margin: auto;
        width: 50%;
        padding: 10px;
    }
</style>

<head>
    <title>Flug Buchen</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
</head>

<% pageContext.setAttribute("items", new String[]{"one", "two", "three"}); %>

<sql:setDataSource
        driver="oracle.jdbc.driver.OracleDriver"
        url="jdbc:oracle:thin:@localhost:1521/xepdb1"
        user="csdc24vz_05"
        password="Eg3Noht"
/>

<html>
<head>
    <title>Welcome</title>
</head>
<body>
<nav class="navbar navbar-inverse">
    <div class="container-fluid">
        <ul class="nav navbar-nav">
            <li class="active"><a href="index.jsp">Home</a></li>
            <li><a href="Flug-Buchen.jsp">Flug Buchen</a></li>
            <li><a href="Flug-Suchen.jsp">Flug suchen</a></li>
            <li><a href="Techniker-Anlegen.jsp">Neuen Techniker anlegen</a></li>
            <li><a href="Techniker-Flugzeug-exemplar.jsp">Techniker Flugzeug exemplar</a></li>
            <li><a href="Logbuch-Ausleihen.jsp">Ausleihen Logbuch anzeigen</a></li>
            </li>
        </ul>
    </div>
</nav>

<div class="center">

    <h3>To be able to create a technician we ask you to enter the personal data first.</h3>

    <br>

    <form action="Techniker-Anlegen.jsp" method="POST">
        <input type="hidden" name="menu" value="Techniker_Anlegen"/>

        <label for="sozialversicherungsnummer">Sozialversicherungsnummer:</label>
        <input type="text" id="sozialversicherungsnummer" name="sozialversicherungsnummer" pattern=".{10}"
               placeholder="1234010190"><br>

        <label for="vorname">First Name:</label>
        <input type="text" id="vorname" name="vorname" placeholder="Lisa"><br>

        <label for="nachname">Last Name:</label>
        <input type="text" id="nachname" name="nachname" placeholder="Musterfrau"><br>

        <label for="telefonnummer">Phone Number:</label>
        <input type="text" id="telefonnummer" name="telefonnummer" placeholder="+43 0664 11223344"><br>

        <label for="strasse">Street:</label>
        <input type="text" id="strasse" name="strasse" placeholder="Favoritenstrasse"><br>

        <label for="hausnummer">House number:</label>
        <input type="text" id="hausnummer" name="hausnummer" placeholder="226"><br>

        <label for="postleitzahl">Postal Code:</label>
        <input type="text" id="postleitzahl" name="postleitzahl" placeholder="1100"><br>

        <label for="ort">City:</label>
        <input type="text" id="ort" name="ort" placeholder="Wien"><br>

        <br><br>
        <input type="Submit" class="btn btn-primary" value="Submit">
        <br>
    </form>


    <c:if test="${!empty param.menu }">

    <c:if test="${!empty param.sozialversicherungsnummer && !empty param.vorname && !empty param.nachname && !empty param.telefonnummer && !empty param.strasse && !empty param.hausnummer && !empty param.postleitzahl && !empty param.ort}">

        <c:set var="person_id" scope="session" value="${param.sozialversicherungsnummer}"/>

        <c:catch var="checkSV">
            <sql:query var="SVPerson"
                       sql="SELECT Sozialversicherungsnummer from Person WHERE Sozialversicherungsnummer Like ?">
                <sql:param value="${person_id}"/>
            </sql:query>
        </c:catch>

        <c:catch var="catchPersonException">
            <sql:update var="person"
                        sql="INSERT INTO Person (Sozialversicherungsnummer, Vorname, Nachname, Strasse, Hausnummer, Postleitzahl, Ort) VALUES (?,?,?,?,?,?,?)">
                <sql:param value="${person_id}"/>
                <sql:param value="${param.vorname}"/>
                <sql:param value="${param.nachname}"/>
                <sql:param value="${param.strasse}"/>
                <sql:param value="${param.hausnummer}"/>
                <sql:param value="${param.postleitzahl}"/>
                <sql:param value="${param.ort}"/>
            </sql:update>
        </c:catch>

        <c:catch var="catchTelefonException">
            <sql:update var="telefonnummer"
                        sql="INSERT INTO Hat_Telefonnummer (Telefonnummer, Sozialversicherungsnummer) VALUES (?,?)">
                <sql:param value="${param.telefonnummer}"/>
                <sql:param value="${person_id}"/>
            </sql:update>
        </c:catch>

        <c:if test="${SVPerson.rows[0].Sozialversicherungsnummer != person_id}">
            <h3> Person has been successfully entered: </h3>
        </c:if>

        <c:if test="${SVPerson.rows[0].Sozialversicherungsnummer == person_id}">
            <h3> A person with this Sozialversicherungsnummer already exists: </h3>
        </c:if>

        <br>

        <c:catch var="catchShowPersonException">
            <sql:query var="angelegtePerson"
                       sql="SELECT Person.*, Hat_Telefonnummer.Telefonnummer FROM Person JOIN Hat_Telefonnummer ON Person.Sozialversicherungsnummer = Hat_Telefonnummer.Sozialversicherungsnummer WHERE Person.Sozialversicherungsnummer  Like ?">
                <sql:param value="${person_id}"/>
            </sql:query>

            <c:set var="angelegte_Person" scope="session" value="${angelegtePerson}"/>

            <p>First name: <b>${angelegtePerson.rows[0].Vorname}</b>
            <p>
            <p>Last name: <b>${angelegtePerson.rows[0].Nachname}</b></p>
            <p>Sozialversicherungsnummmer: <b>${angelegtePerson.rows[0].Sozialversicherungsnummer}</b></p>
            <p>Street: <b>${angelegtePerson.rows[0].Strasse}</b></p>
            <p>House number: <b>${angelegtePerson.rows[0].Hausnummer}</b></p>
            <p>Postal code: <b>${angelegtePerson.rows[0].Postleitzahl} </b></p>
            <p>City: <b>${angelegtePerson.rows[0].Ort}</p>
            <table class=" table table-striped table-responsive
            " border="1">
            <tr>
                <th>Phone number(s)</th>
            </tr>
            <c:forEach var="Datensatz" begin="0" items="${angelegtePerson.rowsByIndex}">
                <tr>
                    <td>${Datensatz[7]}
                </tr>
            </c:forEach>
            </table>

        </c:catch>


        <c:if test="${catchPersonException != null}">
            <!--<p>The type of exception is : ${catchPersonException} <br/>
            There is an exception: ${catchPersonException.message}</p>-->
        </c:if>

        <c:if test="${catchTelefonException != null}">
            <!--<p>The type of exception is : ${catchTelefonException} <br/>
            There is an exception: ${catchTelefonException.message}</p>-->
        </c:if>

        <c:if test="${catchShowPersonException != null}">
            <!--<p>The type of exception is : ${catchShowPersonException} <br/>
            There is an exception: ${catchShowPersonException.message}</p>-->
        </c:if>
        <c:if test="${checkSV != null}">
            <!--<p>The type of exception is : ${checkSV} <br/>
            There is an exception: ${checkSV.message}</p>-->
        </c:if>

        <br>
        <br>
        <button onclick="window.location.href = 'Techniker-Anlegen2.jsp';" class="btn btn-primary">Continue with
            entering the employee data
        </button>

    </c:if>

</div>

<c:if test="${empty param.sozialversicherungsnummer || empty param.vorname || empty param.nachname || empty param.telefonnummer || empty param.strasse || empty param.hausnummer || empty param.postleitzahl || empty param.ort}">
    <c:if test="${empty param.sozialversicherungsnummer }">
        <p>Sozialversicherungsnummer was missing </p>
    </c:if>
    <c:if test="${empty param.vorname }">
        <p>First name was missing}</p>
    </c:if>
    <c:if test="${empty param.nachname }">
        <p>Last name was missing </p>
    </c:if>
    <c:if test="${empty param.telefonnummer }">
        <p>Phone number was missing </p>
    </c:if>
    <c:if test="${empty param.strasse }">
        <p>Street was missing </p>
    </c:if>
    <c:if test="${empty param.hausnummer }">
        <p>House number was missing </p>
    </c:if>
    <c:if test="${empty param.postleitzahl }">
        <p>Postal code was missing </p>
    </c:if>
    <c:if test="${empty param.ort }">
        <p>City was missing </p>
    </c:if>
</c:if>


</c:if>


</body>
</html>

