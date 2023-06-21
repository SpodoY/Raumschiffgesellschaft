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
  <title>Techniker-fuer-Raumschiff-2</title>
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
<h1>Techniker-fuer-Raumschiff-2</h1>

<c:if test="${empty param.LicenseNumber}">
  <p>Es wurde kein Techniker ausgew&auml;hlt!</p>
</c:if>

<c:if test="${!empty param.LicenseNumber}">
  <c:set var = "technician_id" scope = "session" value = "${param.LicenseNumber}"/>
  <h3>Raumschiff (Typennummer), fuer welches der Techniker zustaendig ist</h3>

  <sql:query var="spaceshipForTechnician"
    sql="SELECT distinct t.Lizenznummer, rt.Typennummer, rt.Typenbezeichnung
        FROM Techniker t
        JOIN Raumschiff r ON t.WartetRaumschifftyp = r.Typennummer
        JOIN Raumschifftyp rt ON r.Typennummer = rt.Typennummer
        WHERE t.Lizenznummer = ?">
    <sql:param value="${param.LicenseNumber}" />
  </sql:query>

  <table class="table table-striped table-dark" border="4">
    <tr>
        <th>Lizenznummer</th>
        <th>Typennummer</th>
        <th>Typenbezeichnung</th>
    </tr>

    <c:forEach var="spaceshipForTechnicianRow" begin="0" items="${spaceshipForTechnician.rowsByIndex}">
        <tr>
            <td>${spaceshipForTechnicianRow[0]}</td>
            <td>${spaceshipForTechnicianRow[1]}</td>
            <td>${spaceshipForTechnicianRow[2]}</td>

        </tr>
      </c:forEach>
    </table>
    
        <form method="POST" action="Techniker-Flugzeug-exemplar-3.jsp">
      <input type="hidden" name="technician_id" value="${technician_id}">
      <button type="submit" class="btn btn-primary">Raumschiffdetails</button>
    </form>
</c:if>
</div>

</body>
</html>

