<!doctype html>
<%@ page contentType="text/html" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<style>

    .center {
        margin: auto;
        width: 50%;
        padding: 10px;
    }
</style>

<head>
    <title>Techniker anlegen</title>
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
            <li class="active"><a href="Techniker-Anlegen.jsp">Neuen Techniker anlegen</a></li>
            <li><a href="Techniker-Flugzeug-exemplar.jsp">Techniker Flugzeug exemplar</a></li>
            <li><a href="Logbuch-Ausleihen.jsp">Ausleihen Logbuch anzeigen</a></li>
            </li>
        </ul>
    </div>
</nav>

<div class="center">
    <c:catch var="checkTechnikerExists">
        <sql:query var="technikerExists"
                   sql="select Angestelltennummer, Lizenznummer from Techniker where Angestelltennummer Like ?">
            <sql:param value="${angestellten_id}"/>
        </sql:query>
    </c:catch>

    <c:if test="${checkTechnikerExists != null}">
        <p>The type of exception is : ${checkTechnikerExists} <br/>
            There is an exception: ${checkTechnikerExists.message}</p>
    </c:if>

    <c:if test="${technikerExists.rows[0].Angestelltennummer == angestellten_id}">
        <h3> Employee <b>${angelegte_Person.rows[0].Vorname} ${angelegte_Person.rows[0].Nachname} <br> with employee
            number ${angestellten_id}<br> and Sozialverischerungsnummer ${person_id}<br></b> <br><br>is already a
            technician.
        </h3>

        <c:set var="techniker_id" scope="session" value="${technikerExists.rows[0].Lizenznummer}"/>

        <c:catch var="catchTelefonExistsException">
            <sql:query var="telefonnummerExistsCheck"
                       sql="SELECT Sozialversicherungsnummer FROM Hat_Telefonnummer WHERE Sozialversicherungsnummer LIKE ?">
                <sql:param value="${person_id}"/>
            </sql:query>
        </c:catch>

        <c:if test="${catchTelefonExistsException != null}">
            <!--<p>The type of exception is : ${catchTelefonExistsException} <br/>
            There is an exception: ${catchTelefonExistsException.message}</p>-->
        </c:if>

        <c:catch var="catchShowTechnikerException">
            <c:if test="${telefonnummerExistsCheck.rows[0].Sozialversicherungsnummer == person_id}">
                <sql:query var="angelegterTechniker"
                           sql="SELECT p.*, a.*, t.*, r.*, h.Telefonnummer, b.Bankname FROM Person p JOIN Angestellter a ON p.Sozialversicherungsnummer = a.Sozialversicherungsnummer JOIN Techniker t ON a.Angestelltennummer = t.Angestelltennummer JOIN Raumschifftyp r ON t.WartetRaumschifftyp = r.Typennummer JOIN Hat_Telefonnummer h ON p.Sozialversicherungsnummer = h.Sozialversicherungsnummer JOIN Bank b ON a.Bankleitzahl = b.Bankleitzahl WHERE t.Lizenznummer Like ?">
                    <sql:param value="${techniker_id}"/>
                </sql:query>
            </c:if>

            <c:if test="${telefonnummerExistsCheck.rows[0].Sozialversicherungsnummer != person_id}">
                <sql:query var="angelegterTechniker"
                           sql="SELECT p.*, a.*, t.*, r.*, b.Bankname FROM Person p JOIN Angestellter a ON p.Sozialversicherungsnummer = a.Sozialversicherungsnummer JOIN Techniker t ON a.Angestelltennummer = t.Angestelltennummer JOIN Raumschifftyp r ON t.WartetRaumschifftyp = r.Typennummer JOIN Bank b ON a.Bankleitzahl = b.Bankleitzahl WHERE t.Lizenznummer Like ?">
                    <sql:param value="${techniker_id}"/>
                </sql:query>
            </c:if>
            <br><br>
            <div>
                <h4>Personal data</h4>
                <p><b>${angelegterTechniker.rows[0].Vorname} ${angelegterTechniker.rows[0].Nachname}</b></p>
                <p>Sozialversicherungsnummer: <b>${angelegterTechniker.rows[0].Sozialversicherungsnummer}</b></p>
                <p>
                    Address: ${angelegterTechniker.rows[0].Strasse} ${angelegterTechniker.rows[0].Hausnummer}, ${angelegterTechniker.rows[0].Postleitzahl} ${angelegterTechniker.rows[0].Ort}</p>
                <c:if test="${telefonnummerExistsCheck.rows[0].Sozialversicherungsnummer == person_id}">
                    <table class="table table-striped table-dark" border="1">
                        <tr>
                            <th>Phone number(s)</th>
                        </tr>
                        <c:forEach var="Datensatz" begin="0" items="${angelegterTechniker.rowsByIndex}">
                            <tr>
                                <td>${Datensatz[21]}</td>
                            </tr>
                        </c:forEach>
                    </table>
                </c:if>
                <br>
                <h4>Employee data</h4>
                <p>Employee number: <b>${angelegterTechniker.rows[0].Angestelltennummer}</b></p>
                <p>Account number: ${angelegterTechniker.rows[0].Kontonummer}</p>
                <p>Bank code: ${angelegterTechniker.rows[0].Bankleitzahl}</p>
                <p>Bank name: ${angelegterTechniker.rows[0].Bankname}</p>
                <p>Account balance: ${angelegterTechniker.rows[0].Kontostand}</p>
                <br>
                <h4>Technician data</h4>
                <p>License number: <b>${angelegterTechniker.rows[0].Lizenznummer}</b></p>
                <p>Training degree: ${angelegterTechniker.rows[0].Ausbildungsgrad}</p>
                <p>Takes over the maintenance of the spacecraft type: ${angelegterTechniker.rows[0].Typennummer}</p>
                <br>
                <h4>Spaceship type information</h4>
                <p>Type name: <b>${angelegterTechniker.rows[0].Typenbezeichnung}</b></p>
                <p>Manufacturer name: <b>${angelegterTechniker.rows[0].Herstellername}</b></p>
                <p>Number of seats: ${angelegterTechniker.rows[0].Sitzplatzanzahl}</p>
                <p>Support staff: ${angelegterTechniker.rows[0].Begleitpersonal}</p>

            </div>
        </c:catch>
        <c:if test="${catchShowTechnikerException != null}">
            <!--<p>The type of exception is : ${catchShowTechnikerException} <br/>
            There is an exception: ${catchShowTechnikerException.message}</p>-->
        </c:if>
        <br>
        <br>
        <button onclick="window.location.href = 'index.jsp';" class="btn btn-primary">Get back to Home
        </button>
    </c:if>


    <c:if test="${technikerExists.rows[0].Angestelltennummer != angestellten_id}">

    <h3>Please enter the appropriate technician data for
        <b><br>${angelegte_Person.rows[0].Vorname} ${angelegte_Person.rows[0].Nachname} <br>Employee
            number ${angestellten_id}</b></h3>
    <br><br>

    <form action="Techniker-Anlegen3.jsp" method="POST">
        <input type="hidden" name="menu" value="Techniker_Anlegen3"/>

        <label for="lizenznummer">License number:</label>
        <input type="text" id="lizenznummer" name="lizenznummer" placeholder="T111111111" pattern="T\d{9}"
               title="Please enter a valid License number"><br>

        <label for="ausbildungsgrad">Training degree:</label>
        <select class="form-control" name="ausbildungsgrad" id="ausbildungsgrad" size="1">
            <option value="">Please select an option</option>

            <sql:query var="grade"
                       sql="select Bezeichnung from Ausbildungsgrad">
            </sql:query>

            <c:forEach var="grad" begin="0" items="${grade.rows}">
                <option value="${grad.Bezeichnung}"
                        <c:if test="${param.Bezeichnung eq grad.Bezeichnung}">selected="selected"</c:if>>
                        ${grad.Bezeichnung}
                </option>
            </c:forEach>
        </select>

        <label for="raumschiffTypennummer">Takes over the maintenance of the spacecraft type:</label>
        <select class="form-control" name="raumschiffTypennummer" id="raumschiffTypennummer" size="1">
            <option value="">Please select an option</option>

            <sql:query var="typennummern"
                       sql="select distinct typennummer from Raumschiff">
            </sql:query>

            <c:forEach var="typennummer" begin="0" items="${typennummern.rows}">
                <option value="${typennummer.Typennummer}"
                        <c:if test="${param.Typennummer eq typennummer.Typennummer}">selected="selected"</c:if>>
                        ${typennummer.Typennummer}
                </option>
            </c:forEach>
        </select>
        <br><br>
        <input type="submit" value="Submit" class="btn btn-primary">

        <br>
        <br>
    </form>


    <c:if test="${!empty param.menu }">

    <c:if test="${!empty param.lizenznummer && !empty param.ausbildungsgrad && !empty param.raumschiffTypennummer}">

    <c:set var="techniker_id" scope="session" value="${param.lizenznummer}"/>

    <c:catch var="catchTechnikerException">
        <sql:update var="techniker"
                    sql="INSERT INTO Techniker (Lizenznummer, Angestelltennummer, Ausbildungsgrad, WartetRaumschifftyp) VALUES (?,?,?,?)">
            <sql:param value="${techniker_id}"/>
            <sql:param value="${angestellten_id}"/>
            <sql:param value="${param.ausbildungsgrad}"/>
            <sql:param value="${param.raumschiffTypennummer}"/>
        </sql:update>
    </c:catch>


    <h3> Employee has been successfully entered: </h3>

    <c:catch var="catchShowTechnikerException">
        <sql:query var="angelegterTechniker"
                   sql="SELECT p.*, a.*, t.*, r.*, h.Telefonnummer, b.Bankname FROM Person p JOIN Angestellter a ON p.Sozialversicherungsnummer = a.Sozialversicherungsnummer JOIN Techniker t ON a.Angestelltennummer = t.Angestelltennummer JOIN Raumschifftyp r ON t.WartetRaumschifftyp = r.Typennummer JOIN Hat_Telefonnummer h ON p.Sozialversicherungsnummer = h.Sozialversicherungsnummer JOIN Bank b ON a.Bankleitzahl = b.Bankleitzahl WHERE t.Lizenznummer Like ?">
            <sql:param value="${techniker_id}"/>
        </sql:query>

        <div>
            <h4>Personal data</h4>
            <p><b>${angelegterTechniker.rows[0].Vorname} ${angelegterTechniker.rows[0].Nachname}</b></p>
            <p>Sozialversicherungsnummer: <b>${angelegterTechniker.rows[0].Sozialversicherungsnummer}</b></p>
            <p>
                Address: ${angelegterTechniker.rows[0].Strasse} ${angelegterTechniker.rows[0].Hausnummer}, ${angelegterTechniker.rows[0].Postleitzahl} ${angelegterTechniker.rows[0].Ort}</p>
            <table class="table table-striped table-dark" border="1">
                <tr>
                    <th>Phone number(s)</th>
                </tr>
                <c:forEach var="Datensatz" begin="0" items="${angelegterTechniker.rowsByIndex}">
                    <tr>
                        <td>${Datensatz[21]}</td>
                    </tr>
                </c:forEach>
            </table>
            <br>
            <h4>Employee data</h4>
            <p>Employee number: <b>${angelegterTechniker.rows[0].Angestelltennummer}</b></p>
            <p>Account number: ${angelegterTechniker.rows[0].Kontonummer}</p>
            <p>Bank code: ${angelegterTechniker.rows[0].Bankleitzahl}</p>
            <p>Bank name: ${angelegterTechniker.rows[0].Bankname}</p>
            <p>Account balance: ${angelegterTechniker.rows[0].Kontostand}</p>
            <br>
            <h4>Technician data</h4>
            <p>License number: <b>${angelegterTechniker.rows[0].Lizenznummer}</b></p>
            <p>Training degree: ${angelegterTechniker.rows[0].Ausbildungsgrad}</p>
            <p>Takes over the maintenance of the spacecraft type: ${angelegterTechniker.rows[0].Typennummer}</p>
            <br>
            <h4>Spaceship type information</h4>
            <p>Type name: <b>${angelegterTechniker.rows[0].Typenbezeichnung}</b></p>
            <p>Manufacturer name: <b>${angelegterTechniker.rows[0].Herstellername}</b></p>
            <p>Number of seats: ${angelegterTechniker.rows[0].Sitzplatzanzahl}</p>
            <p>Support staff: ${angelegterTechniker.rows[0].Begleitpersonal}</p>

        </div>
    </c:catch>

    <c:if test="${catchTechnikerException != null}">
        <!--<p>The type of exception is : ${catchTechnikerException} <br/>
        There is an exception: ${catchTechnikerException.message}</p>-->
    </c:if>

    <c:if test="${catchShowTechnikerException != null}">
        <!--<p>The type of exception is : ${catchShowTechnikerException} <br/>
        There is an exception: ${catchShowTechnikerException.message}</p>-->
    </c:if>

    <br>
    <br>
    <button onclick="window.location.href = 'index.jsp';" class="btn btn-primary">Get back to Home
    </button>
</div>

</c:if>

<c:if test="${empty param.lizenznummer || empty param.ausbildungsgrad || empty raumschiffTypennummer}">
    <c:if test="${empty param.lizenznummer }">
        <p>License number was missing </p>
    </c:if>
    <c:if test="${empty param.ausbildungsgrad }">
        <p>Training degree was missing</p>
    </c:if>
    <c:if test="${empty param.raumschiffTypennummer }">
        <p>Spacecraft type was missing </p>
    </c:if>
</c:if>
</c:if>

</c:if>


</body>
</html>

