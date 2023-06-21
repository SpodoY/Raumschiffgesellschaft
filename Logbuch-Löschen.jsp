<!doctype html>
<%@ page contentType="text/html" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<head>
    <title>Logbook booking </title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
</head>

<% pageContext.setAttribute("items", new String[]{"one", "two" , "three" }); %>

<sql:setDataSource driver="oracle.jdbc.driver.OracleDriver"
                   url="jdbc:oracle:thin:@localhost:1521/xepdb1" user="csdc24vz_05" password="Eg3Noht" />

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
            <li><a href="Techniker-Flugzeug-exemplar.jsp">Techniker-Flugzeug-exemplar</a></li>
            <li><a href="Logbuch-Ausleihen.jsp">Ausleihen Logbuch anzeigen</a></li>
            </li>
        </ul>
    </div>
</nav>


<sql:update var="deleteNormal"
            sql="UPDATE Raumschiff SET Logbuchentlehner = NUll WHERE Code = ?">
    <sql:param value="${param.DeletedCode}" />
</sql:update>

<sql:update var="deleteCreated"
            sql="UPDATE Raumschiff SET Logbuchentlehner = NUll WHERE Code = ?">
    <sql:param value="${param.Code}" />
</sql:update>

<h1>Returend Logbook: </h1>
<h2>${param.DeletedCode}</h2>

<form method="post" action="Logbuch-Ausleihen.jsp">
    <button type="submit" class="btn btn-primary"> Zurueck zur Logbuch ausgabe </button>
</form>

<form method="post" action="Logbuch-Loeschen.jsp">
    <button type="submit" class="btn btn-primary"> Zurueck zur Logbuch rueckgabe </button>
</form>


</body>

</html>