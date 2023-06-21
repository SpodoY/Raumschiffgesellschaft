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
      <li ><a href="index.jsp">Home</a></li>
      <li><a href="Flug-Buchen.jsp">Flug Buchen</a></li>
      <li><a href="Flug-Suchen.jsp">Flug suchen</a></li>
      <li><a href="Techniker-Anlegen.jsp">Neuen Techniker anlegen</a></li>
      <li><a href="Techniker-Flugzeug-exemplar.jsp">Techniker-Flugzeug-exemplar</a></li>
      <li class="active"><a href="Logbuch-Ausleihen.jsp">Logbuch anzeigen und Ausleihen</a></li>
      <li><a href="Logbuch-Loeschen.jsp">Logbuch zureckgeben</a></li>
      </li>
    </ul>
  </div>
</nav>




<sql:query var="tables1"
           sql="select Logbuchentlehner,Code  from Raumschiff WHERE Code IS NOT NULL AND Logbuchentlehner IS NOT NULL" >
</sql:query>
<table class="table table-striped table-dark" border="4">
  <h1> Logbooks currently in use </h1>
  <thead>
  <th scope="col">Logbuchentlehner</th>
  <th scope="col">CODE</th>
  </thead>
  <c:forEach var="tabRow" begin="0" items="${tables1.rowsByIndex}">
    <tr>
      <td>${tabRow[0]}</td>
      <td>${tabRow[1]}</td>
    </tr>
  </c:forEach>
</table>


<sql:query var="tables2"
           sql="select Code,Logbuchentlehner  from Raumschiff WHERE Code IS NOT NULL AND Logbuchentlehner IS NULL" >
</sql:query>
<table class="table table-striped table-dark" border="4">
  <h1> Logbooks currently free </h1>
  <thead>
  <th scope="col">Code</th>
  </thead>
  <c:forEach var="tabRow" begin="0" items="${tables2.rowsByIndex}">
    <tr>
      <td>${tabRow[0]}</td>
    </tr>
  </c:forEach>
</table>


<form id="ausleihen" method="post" action="Logbuch-Ausleihen.jsp">
  <input type="hidden" name="menu" value="Logbuch_ausleihen" />

  <h2> Book a logbook</h2>
  <h3>Select a logbook</h3>
  <select class="form-control" name="code" size="1">
    <option value="">No logbook selected</option>

    <sql:query var = "freeCodes"
               sql = "select Code from Raumschiff WHERE Logbuchentlehner IS NULL">
    </sql:query>

    <c:forEach var="availiabelCodes" begin="0" items="${freeCodes.rows}">
    <option value="${availiabelCodes.code}" <c:if test = "${param.code eq availiabelCodes.code}">selected = "selected"</c:if>>
        ${availiabelCodes.code}
      </c:forEach>

  </select>

  <select class="form-control" name="personalNBR" size="1">
    <option value="">No personal number selected</option>

    <sql:query var = "angestellte"
               sql = "select Angestelltennummer from Angestellter">
    </sql:query>

    <c:forEach var="availiabelANG" begin="0" items="${angestellte.rows}">
    <option value="${availiabelANG.Angestelltennummer}" <c:if test = "${param.Angestelltennummer eq availiabelANG.Angestelltennummer}">selected = "selected"</c:if>>
        ${availiabelANG.Angestelltennummer}
      </c:forEach>

  </select>
  <button type="submit" class="btn btn-success">
    <span> Book the logbook </span>
  </button>
</form>

<c:if test="${!empty param.menu}">

  <c:if test="${!empty param.personalNBR}" >
    <c:set var = "booklog_id" scope = "session" value = "${param.personalNBR}"/>
  </c:if>

  <c:choose>
    <c:when test="${empty param.code || empty param.personalNBR}">
      <H1>ENTER INPUT BRE</H1>
    </c:when>


    <c:otherwise>
      <sql:update  var="booklog" sql="UPDATE Raumschiff SET Logbuchentlehner = ? WHERE Code = ?">
        <sql:param value="${booklog_id}" />
        <sql:param value="${param.code}" />
      </sql:update >

    </c:otherwise>
  </c:choose>
</c:if>

<c:if test="${!empty booklog_id}">


  <sql:query var="bookdBooks" sql="SELECT code, LOGBUCHENTLEHNER from Raumschiff Where LOGBUCHENTLEHNER is not null and LOGBUCHENTLEHNER = ? ">
    <sql:param value="${booklog_id}" />
  </sql:query>

  <c:if test="${!empty bookdBooks.rows[0].code}">
    not empty



    <H2>Your booked logbook</H2>
    <table class="table table-striped table-responsive">
      <thead class="thead-light">
      <tr>
        <th scope="col">Booker</th>
        <th scope="col">Logbook</th>
        <th scope="col">Delete a booking</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach var="entries" varStatus="status" begin="0" items="${bookdBooks.rows}">
        <td>${entries.LOGBUCHENTLEHNER}</td>
        <td>${entries.code}</td>
        <td>
          <form method="post" action="Logbuch-Geloescht.jsp">
            <input type="hidden" name="NBR" value="${entries.LOGBUCHENTLEHNER}" />
            <input type="hidden" name="DeletedCode" value="${entries.code}" />
            <input type="hidden" name="Code" value="{null}" />
            <button type="submit" class="btn btn-primary"> Delete </button>
          </form>
        </td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
  </c:if>
</c:if>


</body>
</html>

