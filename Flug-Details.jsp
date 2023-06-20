<!doctype html>
<%@ page contentType="text/html" language="java" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
		<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
			<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

				<style>
					p {
						margin: 0 !important;
						padding: 0;
					}

					h4 {
						margin-right: 20px;
					}

					.main-content {
						width: 80vw;
						margin: auto;
					}

					.flex {
						display: flex;
						flex-direction: row;
						gap: 2;
						align-items: center;
					}
				</style>

				<head>
					<title>Flug-Details</title>
					<meta charset="utf-8">
					<meta name="viewport" content="width=device-width, initial-scale=1">
					<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
					<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
					<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
				</head>

				<sql:setDataSource driver="oracle.jdbc.driver.OracleDriver"
					url="jdbc:oracle:thin:@localhost:1521/xepdb1" user="csdc24vz_05" password="Eg3Noht" />

				<html>

				<body>
					<nav class="navbar navbar-inverse">
						<div class="container-fluid">
							<ul class="nav navbar-nav">
								<li><a href="index.jsp">Home</a></li>
								<li><a href="Flug-Buchen.jsp">Flug Buchen</a></li>
								<li class="active"><a href="Flug-Suchen.jsp">Flug suchen</a></li>
								<li><a href="Techniker-Anlegen.jsp">Neuen Techniker anlegen</a></li>
								<li><a href="Techniker-Flugzeug-exemplar.jsp">Techniker-Flugzeug-exemplar.jsp</a>
								</li>
								<li><a href="Logbuch-Ausleihen.jsp">Ausleihen Logbuch anzeigen</a></li>
								</li>
							</ul>
						</div>
					</nav>

					<div class="main-content">

						<c:if test="${empty param.source || empty param.dest || empty param.flNr}">
							<p> Es wurden nicht alle nötigen Informationen übergeben! </p>
						</c:if>

						<sql:query var="aircraftType" sql="select Typennummer from flug where Flugnummer = ?">
							<sql:param value="${param.flNr}" />
						</sql:query>

						<sql:query var="aircraftInfo" sql="select * from Raumschifftyp where Typennummer = ?">
							<sql:param value="${aircraftType.rows[0].Typennummer}" />
						</sql:query>

						<sql:query var="capacity" sql="select count(*) as anz from Bucht where Flugnummer = ?">
							<sql:param value="${param.flNr}" />
						</sql:query>

						<h1> Flug-Details von Flug ${param.flNr} </h1>

						<h2> Route </h2>
						<div class="flex">
							<h4>From</h4>
							<p> ${param.source} - ${param.depTime} </p>
						</div>
						<div class="flex">
							<h4>To</h4>
							<p> ${param.dest} - ${param.arrTime} </p>
						</div>

						<h2> Aircraft Details </h2>
						<table class="table table-striped table-responsive">
							<thead class="thead-light">
								<tr>
									<th scope="col">Belegte Sitzplaetze</th>
									<th scope="col">Begleitpersonal</th>
									<th scope="col">Typ</th>
									<th scope="col">Hersteller</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="planeSpecs" varStatus="status" begin="0" items="${aircraftInfo.rows}">
									<tr>
										<td>${capacity.rows[0].anz} / ${planeSpecs.Sitzplatzanzahl}</td>
										<td>${planeSpecs.Begleitpersonal}</td>
										<td>${planeSpecs.Typenbezeichnung}</td>
										<td>${planeSpecs.Herstellername}</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>

				</body>

				</html>