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

    <p>Address to be changed for <b>${angelegte_Person.rows[0].Vorname} ${angelegte_Person.rows[0].Nachname}</b> with
        Sozialversicherungsnummmer <b>${person_id}</b>:
    <p>
    <p>Street: ${angelegte_Person.rows[0].Strasse} </p>
    <p>House number: ${angelegte_Person.rows[0].Hausnummer} </p>
    <p>Postal code: ${angelegte_Person.rows[0].Postleitzahl} </p>
    <p>City: ${angelegte_Person.rows[0].Ort}</p>

    <br>
    <br>
    <button onclick="window.location.href = 'Techniker-Anlegen2.jsp';" class="btn btn-default">Do not change address and
        continue with create technician
    </button>
    <br>
    <br>

    <h3>Please fill in the following fields with the new address data</h3>

    <br>

    <form action="Techniker-Anlegen2.jsp" method="POST">
        <input type="hidden" name="menu" value="Adressdaten"/>

        <label for="strasse2">Street:</label>
        <input type="text" id="strasse2" name="strasse2" placeholder="Favoritenstrasse"><br>

        <label for="hausnummer2">House number:</label>
        <input type="text" id="hausnummer2" name="hausnummer2" placeholder="226"><br>

        <label for="postleitzahl2">Postal Code:</label>
        <input type="text" id="postleitzahl2" name="postleitzahl2" placeholder="1100"><br>

        <label for="ort2">City:</label>
        <input type="text" id="ort2" name="ort2" placeholder="Wien"><br>

        <br><br>
        <input type="Submit" class="btn btn-primary" value="Submit new address and continue with create technician">
        <br>
    </form>

    <c:if test="${!empty param.menu }">


        <c:if test="${empty param.strasse2 || empty param.hausnummer2 || empty param.postleitzahl2 || empty param.ort2}">
            <c:if test="${empty param.strasse2 }">
                <p>Street was missing </p>
            </c:if>
            <c:if test="${empty param.hausnummer2 }">
                <p>House number was missing}</p>
            </c:if>
            <c:if test="${empty param.postleitzahl2 }">
                <p>Postal code was missing </p>
            </c:if>
            <c:if test="${empty param.ort2 }">
                <p>City was missing </p>
            </c:if>
        </c:if>
    </c:if>

</div>

</body>
</html>

