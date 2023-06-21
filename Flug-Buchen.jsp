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

<h2>Hello And welcome book your Fligth !</h2>
Here are all availiabel Fligths:

<sql:query var="tables"
           sql="select * from Flug">
</sql:query>

<table class="table table-striped table-dark" border="4">
    <thead>
    <th scope="col">Flugnummer</th>
    <th scope="col">Abflugzeit</th>
    <th scope="col">Ankunftszeit</th>
    <th scope="col">Ablfugplanet</th>
    <th scope="col">Zieplanet</th>
    <th scope="col">Kapit&auml;nspatentsnummer</th>
    <th scope="col">Typennummer</th>
    </thead>
    <c:forEach var="tabRow" begin="0" items="${tables.rowsByIndex}">
        <tr>
            <td>${tabRow[0]}</td>
            <td>${tabRow[1]}</td>
            <td>${tabRow[2]}</td>
            <td>${tabRow[3]}</td>
            <td>${tabRow[4]}</td>
            <td>${tabRow[5]}</td>
            <td>${tabRow[6]}</td>
        </tr>
    </c:forEach>
</table>

<h2> Book your Fligth </h2>

<form id="myForm" method="post" action="Flug-Buchen.jsp">
    <input type="hidden" name="menu" value="Flug_Buchen"/>

    <h3> Select the Passanger </h3>

    <select class="form-control" name="Person" size="1">
        <option value="">kein Name ausgew&auml;hlt</option>

        <sql:query var="personen"
                   sql="select Passagiernummer from Passagier">
        </sql:query>

        <c:forEach var="person" begin="0" items="${personen.rows}">
            <option value="${person.Passagiernummer}"
                    <c:if test="${param.Passagiernummer eq person.Passagiernummer}">selected="selected"</c:if>>
                    ${person.Passagiernummer}
            </option>
        </c:forEach>
    </select>


    <h3> Select the Flug Nummer </h3>

    <select class="form-control" name="Flugnummer" size="1">
        <option value="">Kein Flug ausgew&auml;hlt</option>

        <sql:query var="Flugnum"
                   sql="select Flugnummer from Flug">
        </sql:query>

        <c:forEach var="Flugnum" begin="0" items="${Flugnum.rows}">
            <option value="${Flugnum.Flugnummer}"
                    <c:if test="${param.Flugnummer eq Flugnum.Flugnummer}">selected="selected"</c:if>>
                    ${Flugnum.Flugnummer}
            </option>
        </c:forEach>
    </select>

    <h3> Select the Class </h3>


    <select class="form-control" name="Klasse" size="1">
        <option value="">Keine Klasse ausgew&auml;hlt</option>
        <option value="First-Class">First Class</option>
        <option value="Buissnes-Class">Buissnes Class</option>
        <option value="Econonmy-Class">Econonmy Class</option>
    </select>

    <br>

    <button type="submit" class="btn btn-success">
        <span> Book the fligth </span>
    </button>
</form>


<c:if test="${!empty param.menu }">

    <c:if test="${!empty param.Person && !empty param.Flugnummer && !empty param.Klasse  }">

        <c:set var="buchungs_id" scope="session"
               value="<%= java.util.UUID.randomUUID().toString().replaceAll(\"-\", \"\").substring(0, 30) %>"/>

        <sql:update var="buchen"
                    sql="INSERT INTO Bucht (Buchungsnummer, Klasse, Buchungsdatum, Flugnummer, Passagiernummer) VALUES (?,?,SYSDATE,?,?)">
            <sql:param value="${buchungs_id}"/>
            <sql:param value="${param.Klasse}"/>
            <sql:param value="${param.Flugnummer}"/>
            <sql:param value="${param.Person}"/>
        </sql:update>

        <h2> Erfolgreich gebucht </h2>

    </c:if>
    <c:if test="${empty param.Person || empty param.Flugnummer||empty param.Klasse  }">
        <h3> please select all Options, can't book that way </h3>
        <c:if test="${empty param.Person }">
            <p>Person was missing </p>
        </c:if>
        <c:if test="${empty param.Flugnummer }">
            <p>Flugnummer was missing}</p>
        </c:if>
        <c:if test="${empty param.Klasse }">
            <p>Klasse was missing </p>
        </c:if>
    </c:if>

</c:if>
<c:if test="${!empty buchungs_id}">

    <h2> Last Booked Fligth </h2>

    <sql:query var="gebuchter_Datensatz" sql="select * from Bucht where Buchungsnummer Like  ?">
        <sql:param value="${buchungs_id}"/>
    </sql:query>

    <sql:query var="fluege"
               sql="select * from flug f where f.Flugnummer = ?">
        <sql:param value="${gebuchter_Datensatz.rows[0].Flugnummer}"/>
    </sql:query>


    <table class="table table-striped table-dark" border="4">
        <tr>
            <th>Buchungsnummer</th>
            <th>Klasse</th>
            <th>Buchungsdatum</th>
            <th>Flugnummer</th>
            <th>Passagiernummer</th>
            <th>Flug Details</th>
        </tr>

        <c:forEach var="Datensatz" begin="0" items="${gebuchter_Datensatz.rowsByIndex}">
            <tr>
                <td>${Datensatz[0]}</td>
                <td>${Datensatz[1]}</td>
                <td>${Datensatz[2]}</td>
                <td>${Datensatz[3]}</td>
                <td>${Datensatz[4]}</td>
                <td>
                    <form method="post" action="Flug-Details.jsp">
                        <input type="hidden" name="source" value="${fluege.rows[0].Abflugplanet}"/>
                        <input type="hidden" name="dest" value="${fluege.rows[0].Zielplanet}"/>
                        <input type="hidden" name="flNr" value="${fluege.rows[0].Flugnummer}"/>
                        <input type="hidden" name="depTime" value="${fluege.rows[0].Abflugzeit}"/>
                        <input type="hidden" name="arrTime" value="${fluege.rows[0].Ankunftszeit}"/>
                        <button type="submit" class="btn btn-primary"> Details</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
    </table>
</c:if>


</body>
</html>