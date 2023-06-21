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



<sql:query var="tables1"
           sql="select Logbuchentlehner,Code  from Raumschiff WHERE Code IS NOT NULL AND Logbuchentlehner IS NOT NULL">
</sql:query>
<table class="table table-striped table-dark" border="4">
    <h1> Logbooks currently in use </h1>
    <thead>
    <th scope="col">Logbuchentlehner</th>
    <th scope="col">CODE</th>
    <th scope="col">Delete?</th>
    </thead>
    <c:forEach var="tabRow" begin="0" items="${tables1.rowsByIndex}">
    <tr>
        <td>${tabRow[0]}</td>
        <td>${tabRow[1]}</td>
        <td>
            <form method="post" action="Logbuch-Geloescht.jsp">
                <input type="hidden" name="NBR" value="${tabRow[0]}" />
                <input type="hidden" name="DeletedCode" value="${tabRow[1]}" />
                <input type="hidden" name="Code" value="{null}" />
                <button type="submit" class="btn btn-primary"> Return </button>
            </form>
        </td>
    </tr>
    </c:forEach>

</body>

</html>