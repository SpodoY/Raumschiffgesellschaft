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
  <title>Techniker-fuer-Raumschiff</title>
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
        <li class="active"><a href="Techniker-Flugzeug-exemplar.jsp">Techniker Flugzeug exemplar</a></li>
        <li><a href="Logbuch-Ausleihen.jsp">Ausleihen Logbuch anzeigen</a></li>
      </li>
    </ul>
  </div>
</nav>

<div class="main-content">
  
<h1>Techniker-fuer-Raumschiff</h1>

<h3>Hier eine Uebersicht aller Techniker!</h3>

<sql:query var="techniciantables" 
  sql="SELECT Person.Sozialversicherungsnummer, Angestellter.Angestelltennummer, Techniker.Lizenznummer, Person.Vorname, Person.Nachname FROM Person JOIN Angestellter ON Person.Sozialversicherungsnummer = Angestellter.Sozialversicherungsnummer JOIN Techniker ON Angestellter.Angestelltennummer = Techniker.Angestelltennummer
" >
</sql:query>

<table class="table table-striped table-dark" border="4">
  <thead>
   <th scope="col">Sozialversicherungsnummer</th>
   <th scope="col">Angestelltennummer</th>
   <th scope="col">Lizenznummer</th>
   <th scope="col">Vorname</th>
   <th scope="col">Nachname</th>
  </thead>
  <c:forEach var="techniciantablesRow" begin="0" items="${techniciantables.rowsByIndex}">
      <tr>
      <td>${techniciantablesRow[0]}</td>
      <td>${techniciantablesRow[1]}</td>
      <td>${techniciantablesRow[2]}</td>
      <td>${techniciantablesRow[3]}</td>
      <td>${techniciantablesRow[4]}</td>
      </tr>
  </c:forEach>
  </table>

  <form id="technicianForm" method="post" action="Techniker-Flugzeug-exemplar-2.jsp" >
    <input type="hidden" name="technicianMenu" value="technician_for_spaceship" />
    
    <h3>Techniker auswaehlen</h3>
    
      <select class="form-control" name="LicenseNumber" size="1">
        <option value="">hier auswaehlen</option>        
          <sql:query var="technician" sql="SELECT Lizenznummer FROM Techniker" />  
            <c:forEach var="technician" begin="0" items="${technician.rows}">
              <option value="${technician.Lizenznummer}" <c:if test="${param.Lizenznummer eq technician.Lizenznummer}">selected="selected"</c:if>>
                ${technician.Lizenznummer}
              </option>
            </c:forEach>
      </select>
    <br>
    <button type="submit" class="btn btn-success">
        <span>Confirm your choice</span>
      </button>
  </form>
  </div>

</body>
</html>

