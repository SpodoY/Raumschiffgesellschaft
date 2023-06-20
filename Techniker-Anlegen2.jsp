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
    <c:forEach var="Datensatz" begin="0" items="${angelegte_Person.rowsByIndex}">
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


<h3>Please enter the appropriate employee information for the person listed above</h3>


<form action="Techniker-Anlegen2.jsp" method="POST">
    <input type="hidden" name="menu" value="Techniker_Anlegen2"/>

    <label for="angestelltennummer">Employee Number:</label>
    <input type="text" id="angestelltennummer" name="angestelltennummer"
           placeholder="A123456789"><br>

    <label for="kontonummer">Account number:</label>
    <input type="text" id="kontonummer" name="kontonummer" placeholder="123456789"><br>

    <label for="bankleitzahl">Bank code:</label>
    <input type="text" id="bankleitzahl" name="bankleitzahl" placeholder="12345678901"><br>

    <label for="bankname">Bank name:</label>
    <input type="text" id="bankname" name="bankname" placeholder="Sparkasse"><br>

    <label for="kontostand">Account balance:</label>
    <input type="text" id="kontostand" name="kontostand" placeholder="0.00"><br>

    <input type="submit" value="submit">
</form>


<c:if test="${!empty param.menu }">

    <c:if test="${!empty param.angestelltennummer && !empty param.kontonummer && !empty param.bankleitzahl && !empty param.kontostand && !empty param.bankname}">

        <c:set var="angestellten_id" scope="session" value="${param.angestelltennummer}"/>

        <c:catch var="catchBankException">
            <sql:update var="angestellter"
                        sql="INSERT INTO Bank (Bankleitzahl, Bankname) VALUES (?,?)">
                <sql:param value="${param.bankleitzahl}"/>
                <sql:param value="${param.bankname}"/>
            </sql:update>
        </c:catch>

        <c:catch var="catchAngestellterException">
            <sql:update var="angestellter"
                        sql="INSERT INTO Angestellter (Angestelltennummer, Sozialversicherungsnummer, Kontonummer, Bankleitzahl, Kontostand) VALUES (?,?,?,?,?)">
                <sql:param value="${angestellten_id}"/>
                <sql:param value="${person_id}"/>
                <sql:param value="${param.kontonummer}"/>
                <sql:param value="${param.bankleitzahl}"/>
                <sql:param value="${param.kontostand}"/>

            </sql:update>
        </c:catch>

        <p> Employee has been successfully entered: </p>

        <c:catch var ="catchShowAngestellterException">
            <sql:query var="angelegteAngestellter" sql="SELECT a.*, b.Bankname FROM Angestellter a JOIN Bank b ON a.Bankleitzahl = b.Bankleitzahl WHERE a.Angestelltennummer Like ?">
                <sql:param value="${angestellten_id}" />
            </sql:query>

            <table class="table table-striped table-dark" border="4">
                <tr>
                    <th>Employee Number</th>
                    <th>Account number</th>
                    <th>Bank code</th>
                    <th>Bank name</th>
                    <th>Account balance</th>
                </tr>
                <c:forEach var="Datensatz" begin="0" items="${angelegteAngestellter.rowsByIndex}">
                    <tr>
                        <td>${Datensatz[0]}</td>
                        <td>${Datensatz[2]}</td>
                        <td>${Datensatz[3]}</td>
                        <td>${Datensatz[5]}</td>
                        <td>${Datensatz[4]}</td>
                    </tr>
                </c:forEach>
            </table>
        </c:catch>

        <c:if test="${catchBankException != null}">
            <p>The type of exception is : ${catchBankException} <br/>
                There is an exception: ${catchBankException.message}</p>
        </c:if>

        <c:if test="${catchAngestellterException != null}">
            <p>The type of exception is : ${catchAngestellterException} <br/>
                There is an exception: ${catchAngestellterException.message}</p>
        </c:if>

        <c:if test="${catchShowAngestellterException != null}">
            <p>The type of exception is : ${catchShowAngestellterException} <br/>
                There is an exception: ${catchShowAngestellterException.message}</p>
        </c:if>

        <br>
        <br>
        <button onclick="window.location.href = 'Techniker-Anlegen3.jsp';">Continue with entering the technician data
        </button>

    </c:if>

    <c:if test="${empty param.angestelltennummer || empty param.kontonummer || empty param.bankleitzahl || empty param.kontostand || empty param.bankname}">
        <c:if test="${empty param.angestelltennummer }">
            <p>Employee number was missing </p>
        </c:if>
        <c:if test="${empty param.kontonummer }">
            <p>Account number was missing}</p>
        </c:if>
        <c:if test="${empty param.bankleitzahl }">
            <p>Bank code was missing </p>
        </c:if>
        <c:if test="${empty param.bankname }">
            <p>Bank name was missing </p>
        </c:if>
        <c:if test="${empty param.kontostand }">
            <p>Account balance was missing. If no account balance is known, please enter 0. </p>
        </c:if>
    </c:if>


</c:if>


</body>
</html>

