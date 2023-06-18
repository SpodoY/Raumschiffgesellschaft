<!doctype html>
<%@ page contentType="text/html" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

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

<h2>Hello and welcome!</h2>
<h3>To be able to create a technician we ask you to enter the personal data first.</h3>


<form action="Techniker-Anlegen.jsp" method="POST">
    <input type="hidden" name="menu" value="Techniker_Anlegen" />

    <label for="sozialversicherungsnummer">Sozialversicherungsnummer:</label>
    <input type="text" id="sozialversicherungsnummer" name="sozialversicherungsnummer" pattern=".{10}" placeholder="1234010190"><br>

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

    <input type="submit" value="submit">
</form>




<c:if test="${!empty param.menu }">

    <sql:query var="PersonExists" sql="SELECT Person.*, Hat_Telefonnummer.Telefonnummer FROM Person JOIN Hat_Telefonnummer ON Person.Sozialversicherungsnummer = Hat_Telefonnummer.Sozialversicherungsnummer WHERE Person.Sozialversicherungsnummer  Like ?" >
        <sql:param value="${param.sozialversicherungsnummer}" />
    </sql:query>

    <%-- If Sozialversicherungsnummer already exists.  --%>
    <c:if test="${!empty PersonExists}">
        <c:set var = "person_id" scope = "session" value = "${param.sozialversicherungsnummer}"/>

        <table class="table table-striped table-dark" border="4">
            <tr>
                <th>First Name</th>
                <th>Last Name</th>
                <th>Sozialversicherungsnummmer</th>
                <th>Phone number</th>
                <th>Street</th>
                <th>House number</th>
                <th>Postal code</th>
                <th>City</th>
            </tr>
            <c:forEach var="Datensatz" begin="0" items="${PersonExists.rowsByIndex}">
                <tr>
                    <td>${Datensatz[3]}</td>
                    <td>${Datensatz[4]}</td>
                    <td>${Datensatz[0]}</td>
                    <td>${Datensatz[7]}</td>
                    <td>${Datensatz[1]}</td>
                    <td>${Datensatz[2]}</td>
                    <td>${Datensatz[5]}</td>
                    <td>${Datensatz[6]}</td>
                </tr>
            </c:forEach>
        </table>
    </c:if>

    <%-- if Sozialversicherungsnummer not exists make new entry in Person  --%>
    <c:if test="${empty PersonExists}">
        <c:if test="${!empty param.sozialversicherungsnummer && !empty param.vorname && !empty param.nachname && !empty param.telefonnummer && !empty param.strasse && !empty param.hausnummer && !empty param.postleitzahl && !empty param.ort}">

            <c:set var = "person_id" scope = "session" value = "${param.sozialversicherungsnummer}"/>

            <c:catch var ="catchPersonException">
                <sql:update  var="person" sql="INSERT INTO Person (Sozialversicherungsnummer, Vorname, Nachname, Strasse, Hausnummer, Postleitzahl, Ort) VALUES (?,?,?,?,?,?,?)">
                    <sql:param value="${person_id}" />
                    <sql:param value="${param.vorname}" />
                    <sql:param value="${param.nachname}" />
                    <sql:param value="${param.strasse}" />
                    <sql:param value="${param.hausnummer}" />
                    <sql:param value="${param.postleitzahl}" />
                    <sql:param value="${param.ort}" />
                </sql:update >
            </c:catch>

            <c:catch var ="catchTelefonException">
                <sql:update  var="telefonnummer" sql="INSERT INTO Hat_Telefonnummer (Telefonnummer, Sozialversicherungsnummer) VALUES (?,?)">
                    <sql:param value="${person_id}" />
                    <sql:param value="${param.telefonnummer}" />
                </sql:update >
            </c:catch>

            <p> Person has been successfully entered: </p>

            <c:catch var ="catchShowPersonException">
                <sql:query var="angelegtePersonTelefonnummer" sql="SELECT Person.*, Hat_Telefonnummer.Telefonnummer FROM Person JOIN Hat_Telefonnummer ON Person.Sozialversicherungsnummer = Hat_Telefonnummer.Sozialversicherungsnummer WHERE Person.Sozialversicherungsnummer  Like ?" >
                    <sql:param value="${person_id}" />
                </sql:query>

                <table class="table table-striped table-dark" border="4">
                    <tr>
                        <th>First Name</th>
                        <th>Last Name</th>
                        <th>Sozialversicherungsnummmer</th>
                        <th>Phone number</th>
                        <th>Street</th>
                        <th>House number</th>
                        <th>Postal code</th>
                        <th>City</th>
                    </tr>
                    <c:forEach var="Datensatz" begin="0" items="${angelegtePersonTelefonnummer.rowsByIndex}">
                        <tr>
                            <td>${Datensatz[3]}</td>
                            <td>${Datensatz[4]}</td>
                            <td>${Datensatz[0]}</td>
                            <td>${Datensatz[7]}</td>
                            <td>${Datensatz[1]}</td>
                            <td>${Datensatz[2]}</td>
                            <td>${Datensatz[5]}</td>
                            <td>${Datensatz[6]}</td>
                        </tr>
                    </c:forEach>
                </table>
            </c:catch>

            <c:if test = "${catchPersonException != null}">
                <p>The type of exception is : ${catchPersonException} <br />
                    There is an exception: ${catchPersonException.message}</p>
            </c:if>

            <c:if test = "${catchTelefonException != null}">
                <p>The type of exception is : ${catchTelefonException} <br />
                    There is an exception: ${catchTelefonException.message}</p>
            </c:if>

            <c:if test = "${catchShowPersonException != null}">
                <p>The type of exception is : ${catchShowPersonException} <br />
                    There is an exception: ${catchShowPersonException.message}</p>
            </c:if>


        </c:if>

        <c:if test="${empty param.sozialversicherungsnummer || empty param.vorname || empty param.nachname || empty param.strasse || empty param.hausnummer || empty param.postleitzahl || empty param.ort || empty param.telefonnummer}">
            <h3> Please fill in all fields to create a person </h3>
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


    <br>
    <br>
    <button onclick="window.location.href = 'Techniker-Anlegen2.jsp';">Continue with entering the employee data</button>

</c:if>


</body>
</html>

