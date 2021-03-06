<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c" %>
<!doctype html>
<html class="no-js" lang="en">
	
    <head>
     <script src='js/jquery.min.js'></script>
    <script src='js/jquery-ui.min.js'></script>
    <link rel="stylesheet" href="css/bootstrap.css">
    <script src="js/bootstrap.min.js"></script>
    <link rel="apple-touch-icon" href="apple-touch-icon.png">
    <link rel="stylesheet" href="css/vendor.css">
    <link href='fullcalendar.css' rel='stylesheet' />
    <link href='calendar/fullcalendar.print.css' rel='stylesheet' media='print' />
	<script src='calendar/lib/moment.min.js'></script>
	<script src='calendar/fullcalendar.min.js'></script>
	<link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href=" css/dataTables.bootstrap.min.css">
	<script src="js/jquery.dataTables.min.js"></script>
	<script src="js/dataTables.bootstrap.min.js"></script>
	<script src="js/bootstrap-datepicker.min.js"></script>
        <!-- Theme initialization -->
        <script>
            var themeSettings = (localStorage.getItem('themeSettings')) ? JSON.parse(localStorage.getItem('themeSettings')) :
            {};
            var themeName = themeSettings.themeName || '';
            if (themeName)
            {
                document.write('<link rel="stylesheet" id="theme-style" href="css/app-' + themeName + '.css">');
            }
            else
            {
                document.write('<link rel="stylesheet" id="theme-style" href="css/app.css">');
            }
        </script><link href='fullcalendar.css' rel='stylesheet' />
        
<link href='calendar/fullcalendar.print.css' rel='stylesheet' media='print' />
<script src='calendar/lib/moment.min.js'></script>
<script src='calendar/fullcalendar.min.js'></script>
<link rel="stylesheet" type="text/css" href=" css/dataTables.bootstrap.min.css">
	<script src="js/jquery.dataTables.min.js"></script>
	<script src="js/dataTables.bootstrap.min.js"></script>
	<!-- END IMPORTS -->
    	
    	
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title> PAASCU - Accreditation Schedule Manager </title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="apple-touch-icon" href="apple-touch-icon.png">
        <!-- Place favicon.ico in the root directory -->
        <link rel="stylesheet" href="css/vendor.css">
        <link rel="stylesheet" id="theme-style" href="css/app.css">

		
	
<script>
$(document).ready(function() {
	start();
     $('#smarttable').DataTable( {
        "scrollX": true
    } );
     
     
     $(".nav-tabs a").click(function(){
         $(this).tab('show');
     });

    $('#smarttable').DataTable( {
	
        initComplete: function () {
            this.api().columns().every( function () {
                var column = this;
                var select = $('<select><option value=""></option></select>')
                    .appendTo( $(column.footer()).empty() )
                    .on( 'change', function () {
                        var val = $.fn.dataTable.util.escapeRegex(
                            $(this).val()
                        );
 
                        column
                            .search( val ? '^'+val+'$' : '', true, false )
                            .draw();
                    } );
 
                column.data().unique().sort().each( function ( d, j ) {
                    select.append( '<option value="'+d+'">'+d+'</option>' )
                } );
            } );
        }
    } );

	
		$('#smarttable tbody').on( 'click', 'tr', function () {
		document.location.href='accreditorProfile.html';
		} );
		
} );
$.fn.dataTable.ext.errMode = 'none';


function start(){	


var ID = <%=request.getAttribute("surveyID")%>; 	
$.ajax({
	  url: "ConfirmationPageLoader?surveyID=" + ID,
	  dataType: 'json',
	  async: false,
	  error:function(){alert("fail")},
	  success: function(data) {
		  var add = "";
		  add += ("<ul class='list-group'> <br>") ;		  
	$.each(data, function (key, value){
			
	var title = "<h4>Institution: "+value.title+"</h4><h6>Date: "+value.start+"</h6>";
	$('#surveyTitle').append(title);
	
	for(var i = 0; i < value.programs.length; i++){ 
		var decisionJSON = JSON.stringify(value.programs[i].decisionJSON);
	
	var link = getLink(value.programs[i].surveyType,value.programs[i].PSID, ID, decisionJSON, value.programs[i].boardApprovalDate);	
			 add += (" <li class='list-group-item'>");
			 add += ("<div class='col-md-9' style='position:relative; left:-15px;''><label><h4><p id='program"+value.programs[i].PSID+"'>" + value.programs[i].programName + " : " + value.programs[i].surveyType + "</p></h4></label> </div>	"); 
			    add += (" <button style='position:relative; left:-38px; type='button' class='btn btn-danger btn-sm' onClick="+link+"><i class='fa fa-pencil-square-o'></i> Update Decision</button><br><br> 		");
			    add += ("<table class='table'> ");
			   		add += ("<thead><tr><th style='width: 20%;'>Name</th> <th style='width: 50%;'>Area</th> <th style='width: 30%;'>Confirm Attendance</th></tr></thead> ");
			    	add += (" <tbody> ");			    	
			for(var j = 0; j < value.programs[i].areas.length; j++){
			var checked = checkAttendance(value.programs[i].areas[j].confirmation)			    	 
			    		add += ("<tr > ");
			    		add += ("<td><a id='accLink"+value.programs[i].areas[j].areaID +"' href='ViewAccreditor?accreditorID=" + value.programs[i].areas[j].accreditorID + "' data-toggle='tooltip' title='This will take you to the accreditor page.'>"+ value.programs[i].areas[j].accreditor + "</a></td><td id='area"+value.programs[i].areas[j].areaID +"'>" + value.programs[i].areas[j].area + "</td>");
			    			add += ("<td><label><input type='checkbox' "+ checked +" onclick='confirmAccreditor(" + value.programs[i].PSID + "," + value.programs[i].areas[j].areaID + "," + value.programs[i].areas[j].accreditorID + ")' class='checkbox rounded' value='Confirm Attendance' id='checkbox_confirm"+value.programs[i].areas[j].accreditorID+"'><span>Confirm</span></label> <button class='btn btn-link btn-sm' onclick='changeAcc(" + value.programs[i].areas[j].areaID + ","+value.systemID+","+value.programs[i].PSID+","+ value.programs[i].areas[j].accreditorID+" )' id='changedbutton"+value.programs[i].areas[j].accreditorID+"'><i class='fa fa-pencil'></i>Changed</button></td>");
			 				add += ("</tr> ");
			}
			    		add += ("</tbody> ");
			    add += ("</table> "); 
			 add += ("</li><br>");
	}			
		});	
		  $('#surveyPrograms').append(add + "</ul>");
		}
	});
}
var globalApprovalDate;
//This function checks what type of survey then returns appropriate modal function 
function getLink(type,i,ID,decisionJSON,boardApprovalDate){

globalApprovalDate = boardApprovalDate
	if(type=="Formal"){return "'formalConfirm("+i+","+ID+","+decisionJSON+")'"};
	if(type=="Consultancy"){return "'consultancyConfirm("+i+","+ID+","+decisionJSON+")'"};
	if(type=="Preliminary"){return "'preliminaryConfirm("+i+","+ID+","+decisionJSON+")'"};	
	if(type=="Resurvey"){return "'resurveyConfirm("+i+","+ID+","+decisionJSON+")'"};
	if(type=="Revisit"){return "'revisitConfirm("+i+","+ID+","+decisionJSON+")'"};
}

function checkAttendance(str){	
	if(str=="Confirmed") {return "checked"};
	if(str=="Unonfirmed") {return ""};
}
		 
function confirmAccreditor(PSID, areaID, accID){
	$.ajax({ //CALLING ACCREDITORS WITH EXTRA CHECKING FOR AFFILIATION CONFLICTS
		  url: "ConfirmAttendance?PSID=" + PSID +"&areaID=" + areaID+"&accID=" + accID,		 
		  success: function() {
			 alert("attendance confirmed")
			}
	});					
}

function addAreaTeam(PSID){
	var id = PSID+"_team";	
	
	var textarea= document.getElementById("remarks"+id);
	var select= document.getElementById("areaSelect"+id);	
	var contents = textarea.value;
	if(contents!= ""){contents += ", "}
	textarea.value =  contents + select.options[select.selectedIndex].text;	
}

function resetAreaTeam(PSID){
	var id = PSID+"_team";	
	
	var textarea= document.getElementById("remarks"+id);
	var contents = textarea.value;
	if(contents!= ""){contents += ", "}
	textarea.value =  "";	
}

function resetAreaCommission(PSID){
	var id = PSID+"_commission";	
	
	var textarea= document.getElementById("remarks"+id);
	var contents = textarea.value;
	if(contents!= ""){contents += ", "}
	textarea.value =  "";	
}

function resetAreaBoard(PSID){
	var id = PSID+"_board";	
	
	var textarea= document.getElementById("remarks"+id);
	var contents = textarea.value;
	if(contents!= ""){contents += ", "}
	textarea.value =  "";	
}

function addAreaCommission(PSID){
	var id = PSID+"_commission";	
	
	var textarea= document.getElementById("remarks"+id);
	var select= document.getElementById("areaSelect"+id);	
	var contents = textarea.value;
	if(contents!= ""){contents += ", "}
	textarea.value =  contents + select.options[select.selectedIndex].text;	
}
function addAreaBoard(PSID){
	var id = PSID+"_board";	

	var textarea= document.getElementById("remarks"+id);
	var select= document.getElementById("areaSelect"+id);	
	var contents = textarea.value;
	if(contents!= ""){contents += ", "}
	textarea.value =  contents + select.options[select.selectedIndex].text;	
}

function revisitConfirm(PSID, surveyID) {
	
	
	
	var add = "";	
	$('#modalBody2').html("<div style='width: 49%; float:left;'><h4>Revisit After Deferment</h4> Decision By: <select><option></option><option></option><option>Team</option>Commission<option>Board</option></select></div>");  
	add += ("<form method='post' action='SurveyProgramDecision'> <div>Decision By: <select name='decisionBy'><option> </option><option selected >Team</option><option>Commission</option><option>Board</option></select></div>");
   	 add += ("<div id='modalBody' class='modal-body'>	");
   		 add += ("<div class='form-group' style='width:100%;'> <div> 	");
   		 add += ("<label class='control-label' style='width:100%;'> <br><hr><input name='opt' class='radio ' type='radio' value='Re-accreditation for a period of five years'>	<span>Re-accreditation for a period of five years</span>  <br> <hr></label>");
   			
   		 add += ("<label><input name='opt'class='radio' type='radio'value='Re-accreditation for five years with a written progress report on the'>  <span>Re-accreditation for five years with a WRITTEN PROGRESS REPORT on the</span><select name='yearSelect"+PSID+"'><option>1st</option><option>2nd</option><option>3rd</option><option>4th</option><option>5th</option></select>");
   		 add += ("<span> year for the following areas:</label> <br>");      	
   		 add += ("<div class='form-group'> <label class='control-label'><select id='areaSelect"+PSID+"'><option></option><option>Faculty</option><option>Curriculum and Instructions</option><option>Laboratories</option><option>Libraries</option><option>Community</option></option>Physical Facilities</option><option>Student Services</option><option>Administration</option><option>Research</option><option>Clinical Training</option><option>Other Resources</option></select> <em id='addicon' class='fa fa-plus' onclick='addArea("+PSID+")'></em> </label> <br> <textarea id='remarks"+PSID+"' name='remarks' rows='3'  class='form-control' style='width:100%;'></textarea> </div> <br> <hr>");
     		
   		 add += ("<label><input name='opt'class='radio' type='radio' value='Re-accreditation for five years with a written progress report on the'>  <span>Re-accreditation for five years with a INTERIM VISIT on the</span><select name='yearSelect"+PSID+"'><option>1st</option><option>2nd</option><option>3rd</option><option>4th</option><option>5th</option></select>");
  		 add += ("<span> year for the following areas:</label> <br>");      	
  		 add += ("<div class='form-group'> <label class='control-label'><select id='areaSelect"+PSID+"'><option></option><option>Faculty</option><option>Curriculum and Instructions</option><option>Laboratories</option><option>Libraries</option><option>Community</option></option>Physical Facilities</option><option>Student Services</option><option>Administration</option><option>Research</option><option>Clinical Training</option><option>Other Resources</option></select> <em id='addicon' class='fa fa-plus' onclick='addArea("+PSID+")'></em> </label> <br> <textarea id='remarks"+PSID+"' name='remarks' rows='3'  class='form-control' style='width:100%;'></textarea> </div> <br> <hr>");
 
     	 add += ("<label> <input type='hidden' name='PSID' value='"+PSID+"'><input type='hidden' name='surveyID' value='"+surveyID+"'> <input type='hidden' name='type'value='Revisit'> <input checked name='opt'class='radio' type='radio' value='Re-accreditation deferred'>  <span>Re-accreditation deferred</span> </label> <br>");
  		 add += ("<div class='form-group'> <label class='control-label'>Reason(s) for deferment:</label> <br> <textarea id='remarks"+PSID+"' name='remarks' rows='3'  class='form-control' style='width:100%;'>Lacks Instruction Manuals</textarea> </div>");
   	 add += ("</div> </div></div>");
    add += ("<div id='modalfooter' class='modal-footer'>	<button id='delButton' type='submit' class='close' >Save</button></div>");
    add += ("</form >");
    $('#modalBody2').append(add);
    $('#fullCalModal').modal();
    $('[data-toggle="tooltip"]').tooltip();    
}

function resurveyConfirm(PSID, surveyID, decisionJSON) {
	var add = "";	
	$('#modalBody2').html("<div style='width: 99%; float:left;'><h4>Resurvey Survey</h4>  </div>");  
	add+=("<ul class='nav nav-tabs nav-tabs-bordered'>"
		    +"<li class='nav-item'><a class='nav-link active' data-target='#team' data-toggle='tab' aria-controls='team' role='tab'>Team Decision</a></li>"
		    +"<li class='nav-item'><a class='nav-link' data-target='#commission' data-toggle='tab' aria-controls='commission' role='tab' href='#commission'>Commission Decision</a></li>"
		    +"<li class='nav-item'><a class='nav-link' data-target='#board' data-toggle='tab' aria-controls='board' role='tab' href='#board'>Board Decision</a></li>"
		 +"</ul>");
    add += ("<form method='post' action='SurveyProgramDecision'> <div>Decision By: <select name='decisionBy'><option> </option><option selected >Team</option><option>Commission</option><option>Board</option></select></div>");
   	 add += ("<div id='modalBody' class='modal-body'>		");
   	 

 	 $.each(decisionJSON, function (key, value){
 		
  		
 		 
  if(value.decisionBy == "Team"){ 
 	 var opt1="",opt2="",remarksArea="";
 	add+=("<div id='team' class='tab-pane fade in active'>");
   	 add += ("<div class='form-group' style='width:100%;'> <div>"); 

		 var opt1="",opt2="",remarksArea="";
		 if(value.decision == "Initial accreditation for three (3) years") opt1 = "checked";
		 else if(value.decision == "Accreditation not granted") {opt2 = "checked";remarksArea = value.remarks}
		
   		 add += ("<label class='control-label' style='width:100%;'><br><input "+opt1+" name='opt_team' class='radio ' type='radio' value='Re-accreditation for a period of five years'>	<span>Re-accreditation for a period of five years</span>  <br> <hr></label>");
   		 add += ("<label><input "+opt2+"  name='opt_team'class='radio' type='radio' value='Re-accreditation for five years with a written progress report on the'>  <span>Re-accreditation for five years with a WRITTEN PROGRESS REPORT on the</span><select name='yearSelect"+PSID+"_team'><option>1st</option><option>2nd</option><option>3rd</option><option>4th</option><option>5th</option></select>");
   		 add += ("<span> year for the following areas:</label> <br>");      	
   		 add += ("<div class='form-group'> <label class='control-label'><select id='areaSelect"+PSID+"'><option></option><option>Faculty</option><option>Curriculum and Instructions</option><option>Laboratories</option><option>Libraries</option><option>Community</option></option>Physical Facilities</option><option>Student Services</option><option>Administration</option><option>Research</option><option>Clinical Training</option><option>Other Resources</option></select> <em id='addicon' class='fa fa-plus' onclick='addArea("+PSID+")'></em> </label> <br> <textarea id='remarks"+PSID+"' name='remarks' rows='3'  class='form-control' style='width:100%;'>	</textarea> </div> <br> <hr>");
     		
   		 add += ("<label><input "+opt3+" name='opt_team'class='radio' type='radio' value='Re-accreditation for five years with a written progress report on the'>  <span>Re-accreditation for five years with a INTERIM VISIT on the</span><select name='yearSelect"+PSID+"'><option>1st</option><option>2nd</option><option>3rd</option><option>4th</option><option>5th</option></select>");
  		 add += ("<span> year for the following areas:</label> <br>");      	
  		 add += ("<div class='form-group'> <label class='control-label'><select id='areaSelect"+PSID+"'><option></option><option>Faculty</option><option>Curriculum and Instructions</option><option>Laboratories</option><option>Libraries</option><option>Community</option></option>Physical Facilities</option><option>Student Services</option><option>Administration</option><option>Research</option><option>Clinical Training</option><option>Other Resources</option></select> <em id='addicon' class='fa fa-plus' onclick='addArea("+PSID+")'></em> </label> <br> <textarea id='remarks"+PSID+"' name='remarks' rows='3'  class='form-control' style='width:100%;'></textarea> </div> <br> <hr>");
 
     	 add += ("<label> <input type='hidden' name='PSID' value='"+PSID+"'><input type='hidden' name='surveyID' value='"+surveyID+"'> <input type='hidden' name='type'value='Resurvey'> <input name='opt_team'class='radio' type='radio' value='Re-accreditation deferred'>  <span>Re-accreditation deferred</span> </label> <br>");
  		 add += ("<div class='form-group'> <label class='control-label'>Reason(s) for deferment:</label> <br> <textarea id='remarks"+PSID+"' name='remarks' rows='3'  class='form-control' style='width:100%;'></textarea> </div>");
   	 add += ("</div> </div>");
   	 add += ("</div>")
  }
  
  
});	
   	add += ("</div> </div>");
    add += ("<div id='modalfooter' class='modal-footer'>	<button id='delButton' type='submit' class='close' >Save</button></div>");
    add += ("</form >");
    $('#modalBody2').append(add);
    $('#fullCalModal').modal();
    $('[data-toggle="tooltip"]').tooltip();    
}

function formalConfirm(PSID, surveyID, decisionJSON) {
	var add = "";	
	$('#modalBody2').html("<div style='width: 49%; float:left;'><h4>Formal Survey</h4> </div>");  
	add+=("<ul class='nav nav-tabs nav-tabs-bordered'>"
		    +"<li class='nav-item'><a class='nav-link active' data-target='#team' data-toggle='tab' aria-controls='team' role='tab'>Team Decision</a></li>"
		    +"<li class='nav-item'><a class='nav-link' data-target='#commission' data-toggle='tab' aria-controls='commission' role='tab' href='#commission'>Commission Decision</a></li>"
		    +"<li class='nav-item'><a class='nav-link' data-target='#board' data-toggle='tab' aria-controls='board' role='tab' href='#board'>Board Decision</a></li>"
		 +"</ul>");
	add += ("<form method='post' action='SurveyProgramDecision'> ");
	add += ("<div id='modalBody' class='modal-body'> <div class='tab-content tabs-bordered'>");

 	 $.each(decisionJSON, function (key, value){
 		
 		 
 if(value.decisionBy == "Team"){ 
 		var opt1="",opt2="",remarksArea="";
  		if(value.decision == "Initial accreditation for three (3) years") opt1 = "checked";
   		else if(value.decision == "Accreditation not granted") {opt2 = "checked";remarksArea = value.remarks}
 	add+=("<div id='team' class='tab-pane fade in active'>");
   		 add += ("<div class='form-group' style='width:100%;'> ");
   			 add += ("<label class='control-label' style='width:100%;'> <br><input "+opt1+" name='opt_team' class='radio ' type='radio' value='Initial accreditation for three (3) years'>	<span>Initial accreditation for three (3) years</span> <br> <hr></label>");
   			 add += ("<label> <input type='hidden' name='PSID' value='"+PSID+"'><input type='hidden' name='surveyID' value='"+surveyID+"'> <input type='hidden' name='type'value='Formal'> <input "+opt2+" name='opt_team'class='radio' type='radio' value='Accreditation not granted'>  <span>Accreditation not granted</span> </label> <br>");
  		 add += ("<div class='form-group'> <label class='control-label'>Reason(s) for denial</label> <br> <textarea id='reasons"+PSID+"' name='remarks_team' rows='3'  class='form-control' style='width:100%;'>"+remarksArea+"</textarea> </div>");
   	 add += ("</div></div>");
 		}
 	else if(value.decisionBy=="Commission"){
 		var opt1="",opt2="",remarksArea="";
 	 	if(value.decision == "Initial accreditation for three (3) years") opt1 = "checked";
 		else if(value.decision == "Accreditation not granted") {opt2 = "checked";remarksArea = value.remarks}
 			add+=("<div id='commission' class='tab-pane fade in'>");
 	   		 add += ("<div class='form-group' style='width:100%;'> ");
 	   			 add += ("<label class='control-label' style='width:100%;'> <br><input "+opt1+" name='opt_commission' class='radio ' type='radio' value='Initial accreditation for three (3) years'>	<span>Initial accreditation for three (3) years</span> <br> <hr></label>");
 	   			 add += ("<label> <input type='hidden' name='PSID' value='"+PSID+"'><input type='hidden' name='surveyID' value='"+surveyID+"'> <input type='hidden' name='type'value='Formal'> <input "+opt2+" name='opt_commission'class='radio' type='radio' value='Accreditation not granted'>  <span>Accreditation not granted</span> </label> <br>");
 	  		 add += ("<div class='form-group'> <label class='control-label'>Reason(s) for denial</label> <br> <textarea id='reasons"+PSID+"' name='remarks_commission' rows='3'  class='form-control' style='width:100%;'>"+remarksArea+"</textarea> </div>");
 	   	 add += ("</div></div>");
 		 }
 	else if(value.decisionBy=="Board"){
 		var opt1="",opt2="",remarksArea="";
 		if(value.decision == "Initial accreditation for three (3) years") opt1 = "checked";
 	  	else if(value.decision == "Accreditation not granted") {opt2 = "checked";remarksArea = value.remarks}
 			add+=("<div id='board' class='tab-pane fade in'>");
 	   		 add += ("<div class='form-group' style='width:100%;'> ");
 	   	// Start Input unique for board decision only
 			add += ("<div id='boardDiv'><span>Enter Board Approval Date: </span> <input type='text' id='datepicker' name='decisionDate' value='"+globalApprovalDate+"' /></div>");
 	// End Input unique for board decision only	
 	   		 add += ("<label class='control-label' style='width:100%;'> <br><input "+opt1+" name='opt_board' class='radio ' type='radio' value='Initial accreditation for three (3) years'>	<span>Initial accreditation for three (3) years</span> <br> <hr></label>");
 	   			 add += ("<label> <input type='hidden' name='PSID' value='"+PSID+"'><input type='hidden' name='surveyID' value='"+surveyID+"'> <input type='hidden' name='type'value='Formal'> <input "+opt2+" name='opt_board'class='radio' type='radio' value='Accreditation not granted'>  <span>Accreditation not granted</span> </label> <br>");
 	  		 add += ("<div class='form-group'> <label class='control-label'>Reason(s) for denial</label> <br> <textarea id='reasons"+PSID+"' name='remarks_board' rows='3'  class='form-control' style='width:100%;'>"+remarksArea+"</textarea> </div>");
 	   	 add += (" </div></div>"); 
 		 }
});
   	 add+="</div></div>"
    add += ("<div id='modalfooter' class='modal-footer'>	<button id='delButton' type='submit' class='close' >Save</button></div>");
    add += ("</form >");
    $('#modalBody2').append(add);
    $('#fullCalModal').modal();
    $('[data-toggle="tooltip"]').tooltip();    
}

function preliminaryConfirm(PSID, surveyID, decisionJSON) {
	var add = "";
	
// START OF JSON ITERATION

$('#modalBody2').html("<div style='width: 49%; float:left;'><h4>Preliminary Survey</h4></div>");  
	add+=("<ul class='nav nav-tabs nav-tabs-bordered'>"
		    +"<li class='nav-item'><a class='nav-link active' data-target='#team' data-toggle='tab' aria-controls='team' role='tab'>Team Decision</a></li>"
		    +"<li class='nav-item'><a class='nav-link' data-target='#commission' data-toggle='tab' aria-controls='commission' role='tab' href='#commission'>Commission Decision</a></li>"
		    +"<li class='nav-item'><a class='nav-link' data-target='#board' data-toggle='tab' aria-controls='board' role='tab' href='#board'>Board Decision</a></li>"
		 +"</ul>");
	add += ("<form method='post' action='SurveyProgramDecision'>");
 add += ("<div id='modalBody' class='modal-body'> <div class='tab-content tabs-bordered'>");

 $.each(decisionJSON, function (key, value){
	
 if(value.decisionBy == "Team"){
//  START OF TEAM TAB CONTENT	-PRELIMINARY
 	add+=("<div id='team' class='tab-pane fade in active'>");
   		 add += ("<div class='form-group' style='width:100%;'> <div> 	");
   		 var opt1="",opt2="",opt3="",opt4="",opt5="",remarksArea="";
   		 if(value.decision == "Eligible for formal survey after six months to one year") opt1 = "checked";
   		 else if(value.decision == "Eligible for formal survey after one year") opt2 = "checked";
   		 else if(value.decision== "Consultancy visit after one year to determine readiness for formal survey") opt3 = "checked";
   		 else if(value.decision=="Second preliminary survey") opt4 = "checked";
   		 else if(value.decision =="Consultancy Visit after one year for the following areas:") {opt5 = "checked"; remarksArea = value.remarks}
   			 add += ("<label class='control-label' style='width:100%;'> <br><input "+opt1+" name='opt_team' class='radio ' type='radio' value='Eligible for formal survey after six months to one year'>	<span>Eligible for formal survey after six months to one year </span> <br> <hr></label>");
   			 add += ("<label class='control-label' style='width:100%;'> <input "+opt2+" name='opt_team' class='radio ' type='radio' value='Eligible for formal survey after one year'>	<span>Eligible for formal survey after one year </span> <br> <hr></label>");
   			 add += ("<label class='control-label' style='width:100%;'> <input "+opt3+" name='opt_team' class='radio ' type='radio' value='Consultancy visit after one year to determine readiness for formal survey'>	<span>Consultancy visit after one year to determine readiness for formal survey</span> <br> <hr></label>");
   			 add += ("<label class='control-label' style='width:100%;'> <input "+opt4+" name='opt_team' class='radio ' type='radio' value='Second preliminary survey'>	<span>Second preliminary survey</span> <br> <hr></label>");
   			 add += ("<label> <input type='hidden' name='PSID' value='"+PSID+"'><input type='hidden' name='surveyID' value='"+surveyID+"'> <input type='hidden' name='type'value='Preliminary'> <input "+opt5+" name='opt_team'class='radio' type='radio' value='Consultancy Visit after one year for the following areas:'>   <span>Another Consultancy Visit for the following areas:</span> <select id='areaSelect"+PSID+"_team'><option></option><option>Faculty</option><option>Curriculum and Instructions</option><option>Laboratories</option><option>Libraries</option><option>Community</option></option>Physical Facilities</option><option>Student Services</option><option>Administration</option><option>Research</option><option>Clinical Training</option><option>Other Resources</option></select> <em id='addicon' style='margin-left:5px;' class='fa fa-plus' onclick='addAreaTeam("+PSID+")'></em> <em id='addicon' style='margin-left:5px;'class='fa fa-undo' onclick='resetAreaTeam("+PSID+")'></em> </label> <br>");
  		 add += ("<div class='form-group'> <label class='control-label'>Areas</label> <br> <textarea id='remarks"+PSID+"_team' name='remarks"+PSID+"_team' rows='3'  class='form-control' style='width:100%;'>"+remarksArea+"</textarea> </div>");
   	 	add += ("</div> </div>");
   	add+=("</div>");
 }

 else if(value.decisionBy=="Commission"){
// START OF COMMISSION TAB CONTENT -PRELIMINARY
   	add+=("<div id='commission' class='tab-pane fade'>");
		 add += ("<div class='form-group' style='width:100%;'> <div> 	");
		 var opt1="",opt2="",opt3="",opt4="",opt5="",remarksArea="";
   		 if(value.decision == "Eligible for formal survey after six months to one year") opt1 = "checked";
   		 else if(value.decision == "Eligible for formal survey after one year") opt2 = "checked";
   		 else if(value.decision== "Consultancy visit after one year to determine readiness for formal survey") opt3 = "checked";
   		 else if(value.decision=="Second preliminary survey") opt4 = "checked";
   		 else if(value.decision =="Consultancy Visit after one year for the following areas:") {opt5 = "checked"; remarksArea = value.remarks}
   			 add += ("<label class='control-label' style='width:100%;'> <br><input "+opt1+" name='opt_commission' class='radio ' type='radio' value='Eligible for formal survey after six months to one year'>	<span>Eligible for formal survey after six months to one year </span> <br> <hr></label>");
   			 add += ("<label class='control-label' style='width:100%;'> <input "+opt2+" name='opt_commission' class='radio ' type='radio' value='Eligible for formal survey after one year'>	<span>Eligible for formal survey after one year </span> <br> <hr></label>");
   			 add += ("<label class='control-label' style='width:100%;'> <input "+opt3+" name='opt_commission' class='radio ' type='radio' value='Consultancy visit after one year to determine readiness for formal survey'>	<span>Consultancy visit after one year to determine readiness for formal survey</span> <br> <hr></label>");
   			 add += ("<label class='control-label' style='width:100%;'> <input "+opt4+" name='opt_commission' class='radio ' type='radio' value='Second preliminary survey'>	<span>Second preliminary survey</span> <br> <hr></label>");
   			 add += ("<label> <input type='hidden' name='PSID' value='"+PSID+"'><input type='hidden' name='surveyID' value='"+surveyID+"'> <input type='hidden' name='type'value='Preliminary'> <input "+opt5+" name='opt_commission'class='radio' type='radio' value='Consultancy Visit after one year for the following areas:'>   <span>Another Consultancy Visit for the following areas:</span> <select id='areaSelect"+PSID+"_commission'><option></option><option>Faculty</option><option>Curriculum and Instructions</option><option>Laboratories</option><option>Libraries</option><option>Community</option></option>Physical Facilities</option><option>Student Services</option><option>Administration</option><option>Research</option><option>Clinical Training</option><option>Other Resources</option></select> <em id='addicon' style='margin-left:5px;' class='fa fa-plus' onclick='addAreaCommission("+PSID+")'></em> <em id='addicon' style='margin-left:5px;'class='fa fa-undo' onclick='resetAreaCommission("+PSID+")'></em>  </label> <br>");
  		 add += ("<div class='form-group'> <label class='control-label'>Areas</label> <br> <textarea id='remarks"+PSID+"_commission' name='remarks"+PSID+"_commission' rows='3'  class='form-control' style='width:100%;'> "+remarksArea+"</textarea> </div>");
   	 	add += ("</div> </div>");
	add+=("</div>");
 }

else if(value.decisionBy=="Board"){
// START OF BOARD TAB CONTENT - PRELIMINARY
   	add+=("<div id='board' class='tab-pane fade'>");
		 add += ("<div class='form-group' style='width:100%;'> <div> 	");
// Start Input unique for board decision only
		add += ("<div id='boardDiv'><span>Enter Board Approval Date: </span> <input type='text' id='datepicker' name='decisionDate' value='"+globalApprovalDate+"' /></div>");
// End Input unique for board decision only

		 var opt1="",opt2="",opt3="",opt4="",opt5="",remarksArea="";
   		 if(value.decision == "Eligible for formal survey after six months to one year") opt1 = "checked";
   		 else if(value.decision == "Eligible for formal survey after one year") opt2 = "checked";
   		 else if(value.decision== "Consultancy visit after one year to determine readiness for formal survey") opt3 = "checked";
   		 else if(value.decision=="Second preliminary survey") opt4 = "checked";
   		 else if(value.decision =="Consultancy Visit after one year for the following areas:") {opt5 = "checked"; remarksArea = value.remarks}
   			 add += ("<label class='control-label' style='width:100%;'> <br><input "+opt1+" name='opt_board' class='radio ' type='radio' value='Eligible for formal survey after six months to one year'>	<span>Eligible for formal survey after six months to one year </span> <br> <hr></label>");
   			 add += ("<label class='control-label' style='width:100%;'> <input "+opt2+" name='opt_board' class='radio ' type='radio' value='Eligible for formal survey after one year'>	<span>Eligible for formal survey after one year </span> <br> <hr></label>");
   			 add += ("<label class='control-label' style='width:100%;'> <input "+opt3+" name='opt_board' class='radio ' type='radio' value='Consultancy visit after one year to determine readiness for formal survey'>	<span>Consultancy visit after one year to determine readiness for formal survey</span> <br> <hr></label>");
   			 add += ("<label class='control-label' style='width:100%;'> <input "+opt4+" name='opt_board' class='radio ' type='radio' value='Second preliminary survey'>	<span>Second preliminary survey</span> <br> <hr></label>");
   			 add += ("<label> <input type='hidden' name='PSID' value='"+PSID+"'><input type='hidden' name='surveyID' value='"+surveyID+"'> <input type='hidden' name='type'value='Preliminary'> <input "+opt5+" name='opt_board'class='radio' type='radio' value='Consultancy Visit after one year for the following areas:'>   <span>Another Consultancy Visit for the following areas:</span> <select id='areaSelect"+PSID+"_board'><option></option><option>Faculty</option><option>Curriculum and Instructions</option><option>Laboratories</option><option>Libraries</option><option>Community</option></option>Physical Facilities</option><option>Student Services</option><option>Administration</option><option>Research</option><option>Clinical Training</option><option>Other Resources</option></select> <em id='addicon' style='margin-left:5px;' class='fa fa-plus' onclick='addAreaBoard("+PSID+")'></em> <em id='addicon' style='margin-left:5px;'class='fa fa-undo' onclick='resetAreaBoard("+PSID+")'></em>  </label> <br>");
  		 add += ("<div class='form-group'> <label class='control-label'>Areas</label> <br> <textarea id='remarks"+PSID+"_board' name='remarks"+PSID+"_board' rows='3'  class='form-control' style='width:100%;' value='"+remarksArea+"'>"+remarksArea+"</textarea> </div>");
   	 	add += ("</div> </div>");
	add+=("</div>");
}
	});
// 	END OF FOR EACH
   	
 add+=("</div></div>");
    add += ("<div id='modalfooter' class='modal-footer'>	<button id='delButton' type='submit' class='close' >Save</button></div>");
    add += ("</form >");
    $('#modalBody2').append(add);
    $('#fullCalModal').modal();
    $('[data-toggle="tooltip"]').tooltip();    
    $('#datepicker').datepicker({
 		format: "MM dd, yyyy",
 		autoclose:true,
 	});

}

function consultancyConfirm(PSID, surveyID, decisionJSON) {
	var add = "";	

//  	<div class="modal-header"><button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">�</span> <span class="sr-only">close</span></button><hh4 id="modalTitle" class="modal-title">Computer Science - Consultancy Survey (Survey Details)</h4></div>
 $('#modalBody2').html("<div style='width: 49%; float:left;'><h4>Consultancy Survey</h4></div>");
 add+=("<ul class='nav nav-tabs nav-tabs-bordered'>"
		    +"<li class='nav-item'><a class='nav-link active' data-target='#team' data-toggle='tab' aria-controls='team' role='tab'>Team Decision</a></li>"
		    +"<li class='nav-item'><a class='nav-link' data-target='#commission' data-toggle='tab' aria-controls='commission' role='tab' href='#commission'>Commission Decision</a></li>"
		    +"<li class='nav-item'><a class='nav-link' data-target='#board' data-toggle='tab' aria-controls='board' role='tab' href='#board'>Board Decision</a></li>"
		 +"</ul>");
    add += ("<form method='post' action='SurveyProgramDecision'>");
   	 add += ("<div id='modalBody' class='modal-body'>	 <div class='tab-content tabs-bordered'>");

   	 $.each(decisionJSON, function (key, value){
   		
   	 if(value.decisionBy == "Team"){
   	//  START OF TEAM TAB CONTENT	-consultancy
   	 	add+=("<div id='team' class='tab-pane fade in active'>");
   	   		 add += ("<div class='form-group' style='width:100%;'> <div> 	");
   	   // Start Input unique for board decision only
   			add += ("<div id='boardDiv'><span>Enter Board Approval Date: </span> <input type='text' id='datepicker' name='decisionDate' value='"+globalApprovalDate+"' /></div>");
   	// End Input unique for board decision only  		
   	   		 var opt1="",opt2="",opt3="",opt4="",opt5="",remarksArea="";
   	   		 if(value.decision == "Eligible for formal survey after six months to one year") opt1 = "checked";
   	   		 else if(value.decision == "Eligible for formal survey after one year") opt2 = "checked";
   	   		 else if(value.decision== "Consultancy visit after one year to determine readiness for formal survey") opt3 = "checked";
   	   		 else if(value.decision=="Second consultancy survey") opt4 = "checked";
   	   		 else if(value.decision =="Consultancy Visit after one year for the following areas:") {opt5 = "checked"; remarksArea = value.remarks}
   	   			 add += ("<label class='control-label' style='width:100%;'> <br><input "+opt1+" name='opt_team' class='radio ' type='radio' value='Eligible for formal survey after six months to one year'>	<span>Eligible for formal survey after six months to one year </span> <br> <hr></label>");
   	   			 add += ("<label class='control-label' style='width:100%;'> <input "+opt2+" name='opt_team' class='radio ' type='radio' value='Eligible for formal survey after one year'>	<span>Eligible for formal survey after one year </span> <br> <hr></label>");
   	   			 add += ("<label class='control-label' style='width:100%;'> <input "+opt3+" name='opt_team' class='radio ' type='radio' value='Consultancy visit after one year to determine readiness for formal survey'>	<span>Consultancy visit after one year to determine readiness for formal survey</span> <br> <hr></label>");
   	   			 add += ("<label class='control-label' style='width:100%;'> <input "+opt4+" name='opt_team' class='radio ' type='radio' value='Second consultancy survey'>	<span>Second consultancy survey</span> <br> <hr></label>");
   	   			 add += ("<label> <input type='hidden' name='PSID' value='"+PSID+"'><input type='hidden' name='surveyID' value='"+surveyID+"'> <input type='hidden' name='type'value='Consultancy'> <input "+opt5+" name='opt_team'class='radio' type='radio' value='Consultancy Visit after one year for the following areas:'>   <span>Another Consultancy Visit for the following areas:</span> <select id='areaSelect"+PSID+"_team'><option></option><option>Faculty</option><option>Curriculum and Instructions</option><option>Laboratories</option><option>Libraries</option><option>Community</option></option>Physical Facilities</option><option>Student Services</option><option>Administration</option><option>Research</option><option>Clinical Training</option><option>Other Resources</option></select> <em id='addicon' style='margin-left:5px;' class='fa fa-plus' onclick='addAreaTeam("+PSID+")'></em> <em id='addicon' style='margin-left:5px;'class='fa fa-undo' onclick='resetAreaTeam("+PSID+")'></em> </label> <br>");
   	  		 add += ("<div class='form-group'> <label class='control-label'>Areas</label> <br> <textarea id='remarks"+PSID+"_team' name='remarks"+PSID+"_team' rows='3'  class='form-control' style='width:100%;'>"+remarksArea+"</textarea> </div>");
   	   	 	add += ("</div> </div>");
   	   	add+=("</div>");
   	 }

   	 else if(value.decisionBy=="Commission"){
   	// START OF COMMISSION TAB CONTENT -consultancy
   	   	add+=("<div id='commission' class='tab-pane fade'>");
   			 add += ("<div class='form-group' style='width:100%;'> <div> 	");
   		// Start Input unique for board decision only
   			add += ("<div id='boardDiv'><span>Enter Board Approval Date: </span> <input type='text' id='datepicker' name='decisionDate' value='"+globalApprovalDate+"' /></div>");
   	// End Input unique for board decision only
   			 var opt1="",opt2="",opt3="",opt4="",opt5="",remarksArea="";
   	   		 if(value.decision == "Eligible for formal survey after six months to one year") opt1 = "checked";
   	   		 else if(value.decision == "Eligible for formal survey after one year") opt2 = "checked";
   	   		 else if(value.decision== "Consultancy visit after one year to determine readiness for formal survey") opt3 = "checked";
   	   		 else if(value.decision=="Second consultancy survey") opt4 = "checked";
   	   		 else if(value.decision =="Consultancy Visit after one year for the following areas:") {opt5 = "checked"; remarksArea = value.remarks}
   	   			 add += ("<label class='control-label' style='width:100%;'> <br><input "+opt1+" name='opt_commission' class='radio ' type='radio' value='Eligible for formal survey after six months to one year'>	<span>Eligible for formal survey after six months to one year </span> <br> <hr></label>");
   	   			 add += ("<label class='control-label' style='width:100%;'> <input "+opt2+" name='opt_commission' class='radio ' type='radio' value='Eligible for formal survey after one year'>	<span>Eligible for formal survey after one year </span> <br> <hr></label>");
   	   			 add += ("<label class='control-label' style='width:100%;'> <input "+opt3+" name='opt_commission' class='radio ' type='radio' value='Consultancy visit after one year to determine readiness for formal survey'>	<span>Consultancy visit after one year to determine readiness for formal survey</span> <br> <hr></label>");
   	   			 add += ("<label class='control-label' style='width:100%;'> <input "+opt4+" name='opt_commission' class='radio ' type='radio' value='Second consultancy survey'>	<span>Second consultancy survey</span> <br> <hr></label>");
   	   			 add += ("<label> <input type='hidden' name='PSID' value='"+PSID+"'><input type='hidden' name='surveyID' value='"+surveyID+"'> <input type='hidden' name='type'value='Consultancy'> <input "+opt5+" name='opt_commission'class='radio' type='radio' value='Consultancy Visit after one year for the following areas:'>   <span>Another Consultancy Visit for the following areas:</span> <select id='areaSelect"+PSID+"_commission'><option></option><option>Faculty</option><option>Curriculum and Instructions</option><option>Laboratories</option><option>Libraries</option><option>Community</option></option>Physical Facilities</option><option>Student Services</option><option>Administration</option><option>Research</option><option>Clinical Training</option><option>Other Resources</option></select> <em id='addicon' style='margin-left:5px;' class='fa fa-plus' onclick='addAreaCommission("+PSID+")'></em> <em id='addicon' style='margin-left:5px;'class='fa fa-undo' onclick='resetAreaCommission("+PSID+")'></em> </label> <br>");
   	  		 add += ("<div class='form-group'> <label class='control-label'>Areas</label> <br> <textarea id='remarks"+PSID+"_commission' name='remarks"+PSID+"_commission' rows='3'  class='form-control' style='width:100%;'>"+remarksArea+"</textarea> </div>");
   	   	 	add += ("</div> </div>");
   		add+=("</div>");
   	 }

   	else if(value.decisionBy=="Board"){
   	// START OF BOARD TAB CONTENT - consultancy
   	   	add+=("<div id='board' class='tab-pane fade'>");
   			 add += ("<div class='form-group' style='width:100%;'> <div> 	");
   			 var opt1="",opt2="",opt3="",opt4="",opt5="",remarksArea="";
   	   		 if(value.decision == "Eligible for formal survey after six months to one year") opt1 = "checked";
   	   		 else if(value.decision == "Eligible for formal survey after one year") opt2 = "checked";
   	   		 else if(value.decision== "Consultancy visit after one year to determine readiness for formal survey") opt3 = "checked";
   	   		 else if(value.decision=="Second consultancy survey") opt4 = "checked";
   	   		 else if(value.decision =="Consultancy Visit after one year for the following areas:") {opt5 = "checked"; remarksArea = value.remarks}
   	   			 add += ("<label class='control-label' style='width:100%;'> <br><input "+opt1+" name='opt_board' class='radio ' type='radio' value='Eligible for formal survey after six months to one year'>	<span>Eligible for formal survey after six months to one year </span> <br> <hr></label>");
   	   			 add += ("<label class='control-label' style='width:100%;'> <input "+opt2+" name='opt_board' class='radio ' type='radio' value='Eligible for formal survey after one year'>	<span>Eligible for formal survey after one year </span> <br> <hr></label>");
   	   			 add += ("<label class='control-label' style='width:100%;'> <input "+opt3+" name='opt_board' class='radio ' type='radio' value='Consultancy visit after one year to determine readiness for formal survey'>	<span>Consultancy visit after one year to determine readiness for formal survey</span> <br> <hr></label>");
   	   			 add += ("<label class='control-label' style='width:100%;'> <input "+opt4+" name='opt_board' class='radio ' type='radio' value='Second consultancy survey'>	<span>Second consultancy survey</span> <br> <hr></label>");
   	   			 add += ("<label> <input type='hidden' name='PSID' value='"+PSID+"'><input type='hidden' name='surveyID' value='"+surveyID+"'> <input type='hidden' name='type'value='Consultancy'> <input "+opt5+" name='opt_board'class='radio' type='radio' value='Consultancy Visit after one year for the following areas:'>   <span>Another Consultancy Visit for the following areas:</span> <select id='areaSelect"+PSID+"_board'><option></option><option>Faculty</option><option>Curriculum and Instructions</option><option>Laboratories</option><option>Libraries</option><option>Community</option></option>Physical Facilities</option><option>Student Services</option><option>Administration</option><option>Research</option><option>Clinical Training</option><option>Other Resources</option></select><em id='addicon' style='margin-left:5px;' class='fa fa-plus' onclick='addAreaBoard("+PSID+")'></em> <em id='addicon' style='margin-left:5px;'class='fa fa-undo' onclick='resetAreaBoard("+PSID+")'></em> </label> <br>");
   	  		 add += ("<div class='form-group'> <label class='control-label'>Areas</label> <br> <textarea id='remarks"+PSID+"_board' name='remarks"+PSID+"_board' rows='3'  class='form-control' style='width:100%;'>"+remarksArea+"</textarea> </div>");
   	   	 	add += ("</div> </div>");
   		add+=("</div>");
   	}
   		});
//   	 	END OF FOR EACH
 add+=("</div></div>");

    add += ("<div id='modalfooter' class='modal-footer'>	<button id='delButton' type='submit' class='close' >Save</button></div>");
    add += ("</form >");
    $('#modalBody2').append(add);
    $('#fullCalModal').modal();
    $('[data-toggle="tooltip"]').tooltip(); 
   
}

function changeAcc(areaID, systemID,  programID, oldAccreditorID){
	
	var accreditors = [];
	var counter = 0;
	var area = document.getElementById("area"+areaID).innerHTML;
	
	var accreditorLink = document.getElementById("accLink"+areaID);
	var program = document.getElementById("program"+programID).innerHTML;
alert(systemID+"ggtayo");
	
	$.ajax({ //CALLING ACCREDITORS WITH EXTRA CHECKING FOR AFFILIATION CONFLICTS
		  url: "AccreditorsLoader?SPID=" + programID +"&systemID=" + systemID,
		  dataType: 'json',
		  async: false,
		  success: function(data) {
			  $.each(data, function (key, value){
				  	accreditors.push({});
					accreditors[counter]['accreditorName'] = value.accreditorName;
					accreditors[counter]['primaryArea'] = value.primaryArea;
					accreditors[counter]['secondaryArea'] = value.secondaryArea;
					accreditors[counter]['primaryAreaID'] = value.primaryAreaID;
					accreditors[counter]['secondaryAreaID'] =  value.secondaryAreaID;
					accreditors[counter]['city'] = value.city;
					accreditors[counter]['discipline'] = value.discipline;
					accreditors[counter]['numberSurveys'] = value.numberSurveys;	
					accreditors[counter]['accreditorID'] = value.accreditorID;
					accreditors[counter]['hasAffiliation'] = value.hasAffiliation;
					counter++;
					});					
				
		  }
		});
	
	var add = "";
	//BUILDING THE ACCREDITOR TABLE SPECIFICALLY TAILORED FOR EACH INSTITUTION - PROGRAM - AREA
	var data = accreditors;
	$('#modalTitle').html('<span class="sr-only">close</span></button><h4 id="modalTitle" class="modal-title"> Adding accreditor for ' + program + " - " + area + '</h4>');
	add += "<hr>";
	add += '<div class="table-responsive" style="width:100%; float:right;" id="contenthole">';
	add += '<table id="smarttable" class="table table-striped table-bordered table-hover">';
	add += '<thead><tr><th>ID</th><th>Full Name</th><th>Affiliation</th> <th>Discipline/Specialization</th><th>Primary Survey Area</th><th>Secondary Survey Areas</th><th>Total Surveys</th><th>City</th> </tr></thead>';
	add += '<tbody>';
	
	//VALIDATOR AND STYLE CHANGER
	for(var i = 0; i < data.length; i++){
		add += '<tr>';
		add += '<td>' + data[i].accreditorID + '</td>';
		add += '<td>' + data[i].accreditorName + '</td>';
		if(data[i].hasAffiliation == true){
			add += '<td style="background-color:red;" >Has an Affiliation Conflict</td>';
		}else{
			add += '<td>Has no Affiliation Conflict</td>';
		}
		add += '<td>' + data[i].discipline + '</td>';
		if(data[i].primaryArea != area){
			add += '<td style="background-color:red;" >' + data[i].primaryArea + '</td>';
		}else{
			add += '<td>' + data[i].primaryArea + '</td>';
		}
		
		if(data[i].secondaryArea != area){
			add += '<td style="background-color:red;" >' + data[i].secondaryArea + '</td>';
		}else{
			add += '<td>' + data[i].secondaryArea + '</td>';
		}

		add += '<td>' + data[i].numberSurveys + '</td>';
		add += '<td>' + data[i].city + '</td>';
		add += '</tr>';
	}
	add += '</tbody></table></div>';
	$('#modalBody').html(add);
// 	
	
	//ONCLICK OF ASSIGNING ACCREDITOR
	 $('#smarttable tbody').on('click', 'tr', function () {
			var chosenAccreditor = table.row(this).data();
       		accreditorLink.innerHTML = chosenAccreditor[1];
       		accreditorLink.href= "ViewAccreditor?accreditorID="+chosenAccreditor[0];
       		
       		$.ajax({ //CHANGES ACCREDITORS IN DB
      		  url: "ChangeAccreditor?PSID=" + programID +"&AreaID=" + areaID+"&newAccreditorID=" + chosenAccreditor[0] + "&oldAccreditorID=" + oldAccreditorID,
      		 
      		  success: function() {
      			 alert("Accreditor Successfully Changed");
      			}
      	});			
			
			$('#addModal').modal('toggle');
    } );
	
	$('#addModal').modal();
}



</script>

<style>

	#contenthole{
		
		padding:15px;
		background-color: white;
		

	}

	
	#smarttable th, #smarttable td {		
		text-align: left;
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;	}
		
	#smarttable th{
		background-color:#85CE36; !important
		color:#3c4731;
		font-size:110%;		}

	#smarttable td{
		padding:15px;
		padding-left:10px;
		border: none;
		color:#3c4731;		}


	#smarttable tr:nth-child(even){
		background-color:#e6f2da;}
	
	.container{
		width: 125%;
		overflow:hidden;
		display:block;
		height: 130px;
		z-index:-1;
		margin-left:-15px;}
		
	#smarttable tr:hover {
		background: rgba(255,255,255,1);
		background: -moz-linear-gradient(top, rgba(255,255,255,1) 0%, rgba(246,246,246,1) 47%, rgba(237,237,237,1) 100%);
		background: -webkit-gradient(left top, left bottom, color-stop(0%, rgba(255,255,255,1)), color-stop(47%, rgba(246,246,246,1)), color-stop(100%, rgba(237,237,237,1)));
		background: -webkit-linear-gradient(top, rgba(255,255,255,1) 0%, rgba(246,246,246,1) 47%, rgba(237,237,237,1) 100%);
		background: -o-linear-gradient(top, rgba(255,255,255,1) 0%, rgba(246,246,246,1) 47%, rgba(237,237,237,1) 100%);
		background: -ms-linear-gradient(top, rgba(255,255,255,1) 0%, rgba(246,246,246,1) 47%, rgba(237,237,237,1) 100%);
		background: linear-gradient(to bottom, rgba(255,255,255,1) 0%, rgba(246,246,246,1) 47%, rgba(237,237,237,1) 100%);
		filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#ffffff', endColorstr='#ededed', GradientType=0 );

		-webkit-box-shadow: inset 0px 1px 5px 0px rgba(0,0,0,0.49);
		-moz-box-shadow: inset 0px 1px 5px 0px rgba(0,0,0,0.49);
		box-shadow: inset 0px 1px 5px 0px rgba(0,0,0,0.49);
		cursor: pointer;}

	#bgvid{
		position:relative;
		top:-400px;
		margin-top:0px;
		width:115%	}

	body {		
		font-family: "Lucida Grande",Helvetica,Arial,Verdana,sans-serif;
		font-size: 14px;	}

	#calendar {
		max-width: 900px;
		margin: 0 auto;	}
		
	#bg{
		height: 640px;
		position:fixed;	}
	
	#main{
		position:relative;
		top:-290px;	}
	
	#pnum_danger,#pnum_info,#pnum_warning,#pnum_primary{
		font-size:75px; 
		text-align:center;
		margin-left: -2px;
		padding: 0;
		
		line-height:85px;	}
		
	#pnum_danger{
	color:#ff2b2b;	}
	
	#pnum_warning{
		color:#fe8832;	}
	
	#pnum_info{
		color:#5ecdf3;	}
	
	#pnum_primary{
		color:#85CE36;	}
	
	#psub{
		font-size:17px; 
		color:#bcbcbc;
		text-align:center;
		margin-top: 6px;
		padding: 0;
		line-height:20px;	}
	
	#bc {
		color:white;	}
	
	#bc:hover { 
		color:#85CE36;	}
		
	#addicon:hover{
		color:#85CE36;
		transition: color 0.5s ease;}
	
	#welcome{
		position:relative;
		top:-65px;
		color:white;
		left:20px;
		font-family:Existence-Light;	}
		
	.h1{
		font-size:100%;	}
	
	@font-face {
		font-family: Existence-Light;
		src: url(fonts/Roboto-Thin.ttf);}
		
	@font-face {
		font-family: Existence-Medium;
		src: url(fonts/Roboto-Regular.ttf);	}
			
	#notifcard{
		-webkit-box-shadow: 0px 1px 5px 0px rgba(50, 50, 50, 0.58);
		-moz-box-shadow:    0px 1px 5px 0px rgba(50, 50, 50, 0.58);
		box-shadow:         0px 1px 5px 0px rgba(50, 50, 50, 0.58);
		width:87%;
		left:15px;	}
	
	#customheader{
		overflow:hidden;
		top:122px;  
		height:10px; 
		-webkit-box-shadow: 0px 2px 6px 2px rgba(50, 50, 50, 0.58);
		-moz-box-shadow:    0px 2px 6px 2px rgba(50, 50, 50, 0.58);
		box-shadow:         0px 2px 7px 2px rgba(50, 50, 50, 0.58); 
		font-family:Existence-Medium;
		color:#f4f4f4;
		font-size:90%;
		/* Permalink - use to edit and share this gradient: http://colorzilla.com/gradient-editor/#e2e2e2+0,dbdbdb+50,d1d1d1+51,fefefe+100;Grey+Gloss+%231 */
		background: rgb(226,226,226); /* Old browsers */
		background: -moz-linear-gradient(top,  rgba(226,226,226,1) 0%, rgba(219,219,219,1) 50%, rgba(209,209,209,1) 51%, rgba(254,254,254,1) 100%); /* FF3.6-15 */
		background: -webkit-linear-gradient(top,  rgba(226,226,226,1) 0%,rgba(219,219,219,1) 50%,rgba(209,209,209,1) 51%,rgba(254,254,254,1) 100%); /* Chrome10-25,Safari5.1-6 */
		background: linear-gradient(to bottom,  rgba(226,226,226,1) 0%,rgba(219,219,219,1) 50%,rgba(209,209,209,1) 51%,rgba(254,254,254,1) 100%); /* W3C, IE10+, FF16+, Chrome26+, Opera12+, Safari7+ */
		filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#e2e2e2', endColorstr='#fefefe',GradientType=0 ); /* IE6-9 */	}
	
	#customheader h2{
	color:black;	}
		
	#maincard{
		width:100%;
		padding:0px;
		background-color: #ffffff;
		top:-50px;
		margin-bottom: 10px;
		margin-top: 0px;
		height:700px;
		border-radius: 3px;
	   
		-webkit-box-shadow: 0px 9px 24px 0px rgba(0,0,0,0.75);
		-moz-box-shadow: 0px 9px 24px 0px rgba(0,0,0,0.75);
		box-shadow: 0px 9px 24px 0px rgba(0,0,0,0.75);	}
		
	#bPending{
		position:relative;
		left:-120px;
		float:right;
		-webkit-box-shadow: 0px 4px 7px 1px rgba(0,0,0,0.41);
		-moz-box-shadow: 0px 4px 7px 1px rgba(0,0,0,0.41);
		box-shadow: 0px 4px 7px 1px rgba(0,0,0,0.41);
		}
	#bPending:hover{
		top:3px;
		-webkit-box-shadow: 0px 1px 7px 1px rgba(0,0,0,0.41);
		-moz-box-shadow: 0px 1px 7px 1px rgba(0,0,0,0.41);
		box-shadow: 0px 1px 7px 1px rgba(0,0,0,0.41);

}
		
</style>
    </head>

    <body>
	
        <div class="main-wrapper" style="z-index:1;">
            <div class="app" id="app">
				   
               <aside class="sidebar">
				<img id="bg" src="assets/bg.jpg">
                    <div class="sidebar-container">
                        <div class="sidebar-header">
                            <div class="brand">
                                <div class="logo"style="width:100%"> <img src="assets/logoicon.png" style="width:90%;height:170%; top:-5%;left:-5%; opacity:1"> </div>
                        </div>
                        <nav class="menu">
                            <ul class="nav metismenu" id="sidebar-menu">
                                <li>
                                    <a href="Notifications"> <i class="fa fa-home"></i> Dashboard </a>
                                </li>
								<li class="active open">
                                    <a href="survey.jsp"> <i class="fa fa-table"></i> Survey Schedule </a>
								
                                </li>
								<li>
                                    <a href="addSurvey.jsp"> <i class="fa fa-pencil-square-o"></i> Add New Survey </a>
								</li>
								<li >
                                <a href="#demo" data-toggle="collapse"> <i class="fa fa-file-text-o"></i> Database <i class="fa arrow"></i> </a>
                                    
                                    <ul id="demo" class="collapse">
                                  
                                        <li class="active"> <a href="Accreditors">
    								Accreditors
    							</a> </li>
                                        <li> <a href="Institutions">
    								Institutions
    							</a> </li>
								 <li> <a href="SchoolSystems">
    							                School Systems
    							</a> </li>
								 <li> <a href="Programs">
    								Disciplines </a></li>
								 
                                 
                                    </ul>
                                </li>
                                <li><a href="#demo3" data-toggle="collapse"> <i class="fa fa-bar-chart"></i> Reports <i class="fa arrow"></i> </a><ul id="demo3" class="collapse"><li> <a href="reportGA.html">GA Awardees</a> </li><li> <a href="reportHistory.html">History</a> </li></ul></li>
								<li>
								   
								 </li>
                                
                               
                            </ul>
                        </nav>
                    </div>
                    <footer class="sidebar-footer">
            
			
					
                </aside>
				  
				<div class="container">
	<video poster="assets/banner.jpg" id="bgvid"  playsinline autoplay muted loop>
  <!-- WCAG general accessibility recommendation is that media such as background video play through only once. Loop turned on for the purposes of illustration; if removed, the end of the video will fade in the same way created by pressing the "Pause" button  -->
<source src="assets/vid.mp4" type="video/mp4">
</video>
</div>
            <div id="welcome">
			<h1>Confirmation Page</h1>
			
					
			</div>
			   <header class="header" id="customheader">
			   
					
                </header>
                <article class="content dashboard-page"  >
                    <section class="section" style="position: relative; top:-135px; left:-25px; width:105%;" >
                      
		
					
               <div class="table-responsive" style="width:100%; float:right;" id="contenthole">
					<div class="col-md-12">
					
					
				<!--INSERT attribute get for details of survey  -->								
				<div id="surveyTitle" style='width: 90%; float:left;'></div>
	           		  <br><br><br><hr>
	           		  
	           		  <div id="surveyPrograms">
	           		  </div>
					
												
												</div>
                                               
                                            </div>
                                        </section>
                                    </div>
                                </div>
                            </div>
                        </div>
						
                    </section>
                </article>
             
<!--           MODAL for Change Accreditor -->
         <div id="addModal" class="modal fade">
    		<div class="modal-dialog modal-lg">
        		<div class="modal-content">
            	
            		<div class="modal-header">
                		<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">�</span> <span class="sr-only">close</span></button>
                		<h4 id="modalTitle" class="modal-title"></h4>
            		</div>
            	
            		<div id="modalBody" class="modal-body">
							 <div class="table-responsive" style="width:100%; float:right;" id="contenthole">
										
                                                <table id="smarttable" class="table table-striped table-bordered table-hover">
												   
                                                    <thead>
                                                      <tr>
                                                            <th>Full Name</th>
															<th>Institution</th>
                                                            <th>Discipline/Specialization</th>
                                                            <th>Primary Survey Area</th>
															<th>Secondary Survey Areas</th>
															<th>Total Surveys</th>
                                                            <th>City</th>
                                                            <th>Controls</th>
                                                        </tr>
                                                    </thead>
													
													
													<tbody>
														<c:forEach items="${accreditors}" var="acc">
														
												        <tr>
												        
												          <td><c:out value="${acc.getFullName()}"/></td>
												          <td><c:out value="${acc.getInstitution()}"/></td>
 												          <c:if test="${acc.getInstitution()}">
 												          
												          	
												          	<td style="background-color:red;" ><c:out value="${acc.getInstitution()}"/></td>
												          </c:if>
												          
												           <c:if test="${acc.getInstitution()}">
												          
												          	<td ><c:out value="${acc.getInstitution()}"/></td>
												          </c:if>
												          
												          
												         
												         
												          <td><c:out value="${acc.getDiscipline()}"/></td>
                                                          
                                                          
                                                          <td><c:out value="${acc.getFullName()}"/></td>
												          <c:if test="${acc.getInstitution()}">
												          	
												          	<td style="background-color:red;" ><c:out value="${acc.getPrimaryArea()}"/></td>
												          </c:if>
												          
												           <c:if test="${acc.getInstitution()}">
												          
												          <td><c:out value="${acc.getPrimaryArea()}"/></td>
												          </c:if>
                                                          
                                                          
                                                          
												          <td><c:out value="${acc.getSecondaryArea()}"/></td>
												          <td><c:out value="${acc.getTotalSurveys()}"/></td>
												          <td><c:out value="${acc.getCity()}"/></td>
												          <td>
												          <a href="ViewAccreditor?accreditorID=<c:out value='${acc.getAccreditorID()}'/>">View</a>
												          <a href="EditAccreditor?accreditorID=<c:out value='${acc.getAccreditorID()}'/>">Edit</a>
												          <a href="DeleteAccreditor?accreditorID=<c:out value='${acc.getAccreditorID()}'/>">Delete</a></td>
												        </tr>
												        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
						</div>
            		<div class="modal-footer">
                		<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                		
           		 	</div>
        		</div>
    		</div>
		
		</div> 
		
		<div id="fullCalModal" class="modal fade">
    		<div class="modal-dialog modal-lg" style="width:70%;">
        		<div class="modal-content">
            	
            		<div class="modal-header">
                		<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">�</span> <span class="sr-only">close</span></button>
                		<h4 id="modalTitle" class="modal-title"></h4>
            		</div>
            	
            		<div id="modalBody2" class="modal-body"></div>
            		
        		</div>
    		</div>
		
		</div>
             
        <!-- Reference block for JS -->
        <div class="ref" id="ref">
            <div class="color-primary"></div>
            <div class="chart">
                <div class="color-primary"></div>
                <div class="color-secondary"></div>
            </div>
        </div>

        <script src="js/app.js"></script>

    </body>

</html>