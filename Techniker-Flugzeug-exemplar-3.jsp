<!doctype html>
<%@ page contentType="text/html" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

				<style>
					.main-content {
						width: 80vw;
						margin: auto;
					}
				</style>

<head>
  <title>Techniker-fuer-Raumschiff-3</title>
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
      <li><a href="index.jsp">Home</a></li>
        <li><a href="Flug-Buchen.jsp">Flug Buchen</a></li>
        <li><a href="Flug-Suchen.jsp">Flug suchen</a></li>
        <li><a href="Techniker-Anlegen.jsp">Neuen Techniker anlegen</a></li>
        <li class="active"><a href="Techniker-Flugzeug-exemplar.jsp">Techniker-Flugzeug-exemplar</a></li>
        <li><a href="Logbuch-Ausleihen.jsp">Ausleihen Logbuch anzeigen</a></li>
      </li>
    </ul>
  </div>
</nav>

<div class="main-content">
<h1>Techniker-fuer-Raumschiff-3</h1>

<c:if test="${empty param.technician_id}">
  <p>Es wurde kein Techniker ausgew&auml;hlt!</p>
</c:if>

<c:if test="${!empty param.technician_id}">
  <h3>Raumschiffdetails</h3>

  <sql:query var="spaceshipDetails"
    sql="SELECT *
        FROM Raumschiff
        WHERE Typennummer = (
          SELECT WartetRaumschifftyp
          FROM Techniker
          WHERE Lizenznummer = ?)">
    <sql:param value="${technician_id}" />
  </sql:query>
</c:if>

<table class="table table-striped table-dark" border="4">
  <thead>
   <th scope="col">Inventarnummer</th>
   <th scope="col">Fertigungsjahr</th>
   <th scope="col">Lichtjahr</th>
   <th scope="col">Typennummer</th>
   <th scope="col">Code</th>
   <th scope="col">Logbuchentlehner</th>
  </thead>
  <c:forEach var="spaceshipDetailsRow" begin="0" items="${spaceshipDetails.rowsByIndex}">
      <tr>
      <td>${spaceshipDetailsRow[0]}</td>
      <td>${spaceshipDetailsRow[1]}</td>
      <td>${spaceshipDetailsRow[2]}</td>
      <td>${spaceshipDetailsRow[3]}</td>
      <td>${spaceshipDetailsRow[4]}</td>
      <td>${spaceshipDetailsRow[5]}</td>
      </tr>
  </c:forEach>
  </table>
  </div>

</body>
</html>
