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
					<title>Flug-Suchen</title>
					<meta charset="utf-8">
					<meta name="viewport" content="width=device-width, initial-scale=1">
					<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
					<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
					<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
				</head>

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
						<h1> Flug-Ergebnisse </h1>

						<c:if test="${empty param.SrcPlanet}">
							<p> Es wurde kein Flug ausgew&auml;hlt! </p>
						</c:if>

						<c:if test="${!empty param.SrcPlanet}">
							<sql:query var="fluegeDst"
								sql="select Flugnummer, Abflugzeit, Ankunftszeit, Abflugplanet, Zielplanet from flug f where f.Abflugplanet = ?">
								<sql:param value="${param.SrcPlanet}" />
							</sql:query>

							<c:forEach var="reachableFlights" begin="0" items="${fluegeDst.rows}">

								<table class="table table-striped table-responsive">
									<thead class="thead-light">
										<tr>
											<th scope="col">Flugnummer</th>
											<th scope="col">Abflugzeit</th>
											<th scope="col">Ankunftszeit</th>
											<th scope="col">Abflugplanet</th>
											<th scope="col">Zielplanet</th>
										</tr>
									</thead>
									<tbody>
										<sql:query var="fluegeDst"
											sql="select Flugnummer, Abflugzeit, Ankunftszeit, Abflugplanet, Zielplanet from flug f where f.Abflugplanet = ?">
											<sql:param value="${param.SrcPlanet}" />
										</sql:query>

										<c:forEach var="fluege" varStatus="status" begin="0" items="${fluegeDst.rows}">
											<td>${fluege.Flugnummer}</td>
											<td>${fluege.Abflugzeit}</td>
											<td>${fluege.Ankunftszeit}</td>
											<td>${fluege.Abflugplanet}</td>
											<td>${fluege.Zielplanet}</td>
											<td>
												<form method="post" action="Flug-Details.jsp">
													<input type="hidden" name="source" value="${fluege.Abflugplanet}" />
													<input type="hidden" name="dest" value="${fluege.Zielplanet}" />
													<input type="hidden" name="flNr" value="${fluege.Flugnummer}" />
													<input type="hidden" name="depTime" value="${fluege.Abflugzeit}" />
													<input type="hidden" name="arrTime" value="${fluege.Ankunftszeit}" />
													<button type="submit" class="btn btn-primary"> Details </button>
												</form>
											</td>
											</tr>
										</c:forEach>
									</tbody>
								</table>

							</c:forEach>

							<form>
								<input type="hidden" name="srcPlanet" value="${param.SrcPlanet}" />
							</form>
					</div>
					</c:if>

				</body>

				</html>