<?xml version="1.0" ?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
<!--<xsl:output method="html" version="4.0"
encoding="iso-8859-1" indent="yes"/>-->
<xsl:output 
    method='html' 
    indent='yes'
		cdata-section-elements=''
		omit-xml-declaration='yes'
    doctype-public="-//W3C//DTD XHTML Basic 1.1//EN"
    doctype-system="http://www.w3.org/TR/xhtml-basic/xhtml-basic11.dtd"/>
<xsl:template match="/">
<html>
<head>
<title>PTF LOG - <xsl:value-of select="Log/testName"/></title>
</head>
<script type="text/JavaScript">

function show(id)
{
     if (document.getElementById(id).style.display == 'none')
     {
          document.getElementById(id).style.display = '';
     }
}
function hide(id)
{
          document.getElementById(id).style.display = 'none';

}
function fontResize()
{
var defaultStyleFont = document.getElementById("StepLog");
var cs=document.defaultView.getComputedStyle(defaultStyleFont,null);
var styleFont=cs.getPropertyValue('font-size');
alert(styleFont);
var updStyleFont=(parseInt(styleFont) + 0.50) + "px";
alert(updStyleFont);
defaultStyleFont.style.fontSize=updStyleFont;
location.reload();
}
function screenshoturl(lineNo)
{
var logurl;
var a = lineNo;
logurl = window.location.protocol + "//" + window.location.host + window.location.pathname;
var wlp=window.location.pathname
var wlp=wlp.replace(/%20/gi," ");
logurl = window.location.protocol + "//" + window.location.host + wlp;
var arrlogurl=logurl.split('.html');
var scrshotpath=arrlogurl[0].concat("-","Line",a,".jpg");
var scrpath=scrshotpath.replace("file:","\\\\");
scrpath = scrpath.replace("logpath","image")
window.open(scrpath,"Image");
}
function openPIA(urlPath)
{
window.open(urlPath);
}
function showLog(lno)
{
  document.getElementById('expandImg'.concat(lno)).style.display = 'none';
	document.getElementById('collapseImg'.concat(lno)).style.display = '';
	document.getElementById('msgLog'.concat(lno)).style.display = '';
	document.getElementById('exprLog'.concat(lno)).style.display = '';
	document.getElementById('detailLog'.concat(lno)).style.display = '';
	document.getElementById('calledLog'.concat(lno)).style.display = '';
	document.getElementById('commandID'.concat(lno)).style.display = '';
}
function hideLog(lno)
{
  document.getElementById('collapseImg'.concat(lno)).style.display = 'none';
	document.getElementById('msgLog'.concat(lno)).style.display = '';
	document.getElementById('expandImg'.concat(lno)).style.display = '';
	document.getElementById('exprLog'.concat(lno)).style.display = 'none';
	document.getElementById('detailLog'.concat(lno)).style.display = 'none';
	document.getElementById('calledLog'.concat(lno)).style.display = 'none';
	document.getElementById('commandID'.concat(lno)).style.display = 'none';
}
function showLogExpand(countln)
{
<xsl:text disable-output-escaping="yes">	
for(var i=1;i&lt;=parseInt(countln);i++)
{
  document.getElementById('expandImg'.concat(i)).style.display = 'none';
	document.getElementById('collapseImg'.concat(i)).style.display = '';
	document.getElementById('msgLog'.concat(i)).style.display = '';
	document.getElementById('exprLog'.concat(i)).style.display = '';
	document.getElementById('detailLog'.concat(i)).style.display = '';
	document.getElementById('calledLog'.concat(i)).style.display = '';
	document.getElementById('commandID'.concat(i)).style.display = '';
}</xsl:text>	
}
function showLogCollapse(countln)
{
<xsl:text disable-output-escaping="yes">
for(var i=1;i&lt;=parseInt(countln);i++)
{
  document.getElementById('collapseImg'.concat(i)).style.display = 'none';
	document.getElementById('msgLog'.concat(i)).style.display = '';
	document.getElementById('expandImg'.concat(i)).style.display = '';
	document.getElementById('exprLog'.concat(i)).style.display = 'none';
	document.getElementById('detailLog'.concat(i)).style.display = 'none';
	document.getElementById('calledLog'.concat(i)).style.display = 'none';
	document.getElementById('commandID'.concat(i)).style.display = 'none';
}</xsl:text>
}
</script>
<style>
div{
        margin: 0;
        padding: 0;
        border: 0;
        font-weight: normal;
        font-style: inherit;
        font-size: 100%;
        font-family: inherit;
        vertical-align: baseline;
}
h1 { font-family: Arial, sans-serif; font-size: 30px; color: #004080;}
#LeftNavLinks{ font-family: Arial, sans-serif; font-size: 12px; color: #102541;}
#HeaderText{ font-family: Arial, sans-serif; font-size: 30px; color: #102541; word-spacing="10px" ;letter-spacing="2px"}
#FrameContent { font-family: Arial, sans-serif; font-size: 8px; color: #004080;}
#TestNameResult { font-family: Arial, sans-serif; font-size: 14px; color: #02052C;}
#PassTableCell {background-color:#1AB541;}
#FailTableCell {background-color:#F93606;}
#WarningTableCell {background-color:#F9F906;}
#FatalErrTableCell {background-color:#9D1D24;color:#FFFFFF}
#LogInfo { font-family: Arial, sans-serif; font-size: 12px; color: #02052C;}
#ExecutionOptionsInfo { font-family: Arial, sans-serif; font-size: 12px; color: #02052C;}
#SystemInfo { font-family: Arial, sans-serif; font-size: 12px; color: #02052C;}
#PTFEnvInfo { font-family: Arial, sans-serif; font-size: 12px; color: #02052C;}
#StepwiseInfo { font-family: Arial, sans-serif; font-size: 11px; color: #02052C;}
#FatalErrStepLog {text-align:center;background-color:#FEFA08;}
#PassStepLog {text-align:center; background-color:#1AB541;}
#InfoStepLog {text-align:center; background-color:#59E2EF;}
#FailStepLog {text-align:center; background-color:#F93606;}
#NoneStepLog {text-align:center; background-color:#F7FAFA;}
#StepLog{display:table;position:relative;left:40px;}
#ExpLink,#ColLink{position:relative;left:40px;}
#NoneTableCell{background-color:#FFFFFF;}
</style>

<body bgcolor="#f2f2f2" width="85%">

<table width="100%" border="1" cellspacing="0" cellpadding="0">
	<tr>
		<td></td>
		<td width="100%" bgcolor="#BBCFE9" valign="top">
			<br></br>
			<p id="HeaderText" align="center"><b>PTF EXECUTION LOG</b></p>
			<br></br>
		</td>
		<td></td>
	</tr>
</table>
<table width="100%" height="100%" border="1" cellspacing="0" cellpadding="0">
	<tr>
		<!--<td width="10" bgcolor="#c5dbe4"> &nbsp; </td> 336699#c5d4e9-->
		<td width="10%" bgcolor="#BBCFE9" valign="top">
				<h4 align="center">
				<br></br>
				<br></br>
				<a id="LeftNavLinks" href="#" title="Go to Log Information" onclick="show('LogInfo');hide('ExecutionOptionsInfo');hide('SystemInfo');hide('PTFEnvInfo');hide('StepwiseInfo')"><b>Log Info</b></a> 
				<pre></pre>
				<a id="LeftNavLinks" href="#" title="Go to Execution Option Information" onclick="hide('LogInfo');show('ExecutionOptionsInfo');hide('SystemInfo');hide('PTFEnvInfo');hide('StepwiseInfo')"><b>Execution Options</b></a>
				<pre></pre>
				<a id="LeftNavLinks" href="#" title="Go to System Information" onclick="hide('LogInfo');hide('ExecutionOptionsInfo');show('SystemInfo');hide('PTFEnvInfo');hide('StepwiseInfo')"><b>System Info</b></a> 
				<pre></pre>
				<a id="LeftNavLinks" href="#" title="Go to PTF Information" onclick="hide('LogInfo');hide('ExecutionOptionsInfo');hide('SystemInfo');show('PTFEnvInfo');hide('StepwiseInfo')"><b>PTF Environment Info</b></a> 
				<pre></pre>
				<a id="LeftNavLinks" href="#" title="Go to Step Wise Log Information" onclick="hide('LogInfo');hide('ExecutionOptionsInfo');hide('SystemInfo');hide('PTFEnvInfo');show('StepwiseInfo')"><b>Step-wise Log Info</b></a>
				</h4>
		</td>
		<td width="90%" bgcolor="#F8F9FC" cellspacing="0" cellpadding="0" valign="top"> 
				<div align="center" valign="top">
				<br></br>
						 <table id="TestNameResult" align="center" border="0" cellspacing="0" cellpadding="5">
						 				<tr>
												<td><b>Test Name:</b></td>
												<td><xsl:value-of select="Log/testName"/></td>
												<xsl:choose>
												<xsl:when test="Log[scriptFinalResult = 'LogFatalError'] or Log[scriptFinalResult = '121']">
          												<td><b>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;Overall Result:</b></td>
																	<td id="FatalErrTableCell">&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;<b>Fatal Error</b>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;</td>
												</xsl:when>
												<xsl:when test="Log[scriptFinalResult = 'LogFail'] or Log[scriptFinalResult = '120']">
          												<td><b>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;Overall Result:</b></td>
																	<td id="FailTableCell">&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;<b>Fail</b>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;</td>
												</xsl:when>
												<xsl:when test="Log[scriptFinalResult = 'LogWarning'] or Log[scriptFinalResult = '115']">
          												<td><b>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;Overall Result:</b></td>
																	<td id="WarningTableCell">&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;<b>Warning</b>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;</td>
												</xsl:when>
												<xsl:when test="Log[scriptFinalResult = 'LogPass'] or Log[scriptFinalResult = '110']">
          												<td><b>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;Overall Result:</b></td>
																	<td id="PassTableCell">&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;<b>Pass</b>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;</td>
												</xsl:when>
												<xsl:when test="Log[scriptFinalResult = 'LogNone'] or Log[scriptFinalResult = '100']">
          												<td><b>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;Overall Result:</b></td>
																	<td id="NoneTableCell">&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;<b>None</b>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;</td>
												</xsl:when>
												<!--<xsl:otherwise>
          												<td><b>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;Overall Result:</b></td>
																	<td id="PassTableCell">&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;<b>Pass</b>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;</td>
												</xsl:otherwise> -->
												</xsl:choose>
										</tr>
						 </table>
						
				</div>
				<div id="LogInfo" style="DISPLAY: none">
				<table align="left" border="0" cellspacing="10" cellpadding="0">
							 		 <br></br>
									 <pre><br></br></pre>
							 		 <tr><td>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									 			   &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
													 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0; Test Name:&#xa0;&#xa0;</td>
													 <td><xsl:value-of select="Log/testName"/></td></tr>
									 <tr><td>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									 			   &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
													 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0; Case Name:&#xa0;&#xa0;</td>
													 <td><xsl:value-of select="Log/caseName"/></td></tr>
									 <tr><td>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									 			   &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
													 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0; Log Folder:&#xa0;&#xa0;</td>
													 <td><xsl:value-of select="Log/logFolder"/></td></tr>	
									 <tr><td>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									 			   &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
													 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0; Log Caption:&#xa0;&#xa0;</td>
													 <td><xsl:value-of select="Log/logCaption"/></td></tr>			 
				</table>
				</div>
				<div id="ExecutionOptionsInfo" style="DISPLAY: none">
				<table align="left" border="0" cellspacing="10" cellpadding="0">
							 		 <br></br>
									 <pre><br></br></pre>
							 		 <tr><td>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									 				 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;																																							 
									 				 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0; Name: &#xa0;&#xa0;</td>
													 <td><xsl:value-of select="Log/executionOptions/executionOptionName"/></td></tr>
							 		 <tr><td>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									         &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									 				 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0; Prompt Options: &#xa0;&#xa0;</td>
													 <td><xsl:value-of select="Log/executionOptions/prompt"/></td></tr>
									 <tr><td>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									 				 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									 				 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0; Appl URL: &#xa0;&#xa0;</td>
													 <td><xsl:value-of select="Log/executionOptions/url"/>&#xa0;&#xa0;&#xa0;<a href="javascript:openPIA('{Log/executionOptions/url}')" title="Go to Application">Click here to open Application</a></td></tr>
									 <tr><td>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									 				 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									 				 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0; Portal URL: &#xa0;&#xa0;</td>
													 <xsl:for-each select="Log/extras/extra[logLabel='PORTAL']">
													 <td><xsl:value-of select="logValue"/></td>
													 </xsl:for-each>
									 </tr>
									 <tr><td>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									         &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									 				 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0; Appl User: &#xa0;&#xa0;</td>
													 <td><xsl:value-of select="Log/executionOptions/userID"/></td></tr>
									 <tr><td>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									         &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									 				 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0; Appl Date Format: &#xa0;&#xa0;</td>
													 <td><xsl:value-of select="Log/executionOptions/dateFormat"/></td></tr>
									 <tr><td>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									         &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									 				 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0; Output LogFolder: &#xa0;&#xa0;</td>
													 <td><xsl:value-of select="Log/logFolder"/></td></tr>
									 <tr><td>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									 				 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
													 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0; Output Verbose: &#xa0;&#xa0;</td>
													 <td><xsl:value-of select="Log/executionOptions/verbose"/></td></tr>
									 <tr><td>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									 				 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
													 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0; Debug - Skip PageSave: &#xa0;&#xa0;</td>
													 <td><xsl:value-of select="Log/executionOptions/skipSave"/></td></tr>
									 <tr><td>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									 				 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;																																							 
									 				 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0; Debug - Skip RunRequest: &#xa0;&#xa0;</td>
													 <td><xsl:value-of select="Log/executionOptions/skipRun"/></td></tr>
				</table>
				</div>
				<div id="SystemInfo" style="DISPLAY: none">
				<table align="left" border="0" cellspacing="10" cellpadding="0">
							 		 <br></br>
									 <pre><br></br></pre>
							 		 <tr><td>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									 				 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;																																							 
									 				 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0; Machine Name: &#xa0;&#xa0;</td>
													 <td><xsl:value-of select="Log/machineName"/></td></tr>
							 		 <tr><td>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									         &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									 				 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0; Screen Resolution: &#xa0;&#xa0;</td>
													 <xsl:for-each select="Log/extras/extra[logLabel='Screen resolultion :']">
													 <td><xsl:value-of select="logValue"/></td>
													 </xsl:for-each>
									 </tr>
									 <tr><td>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									 				 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									 				 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0; Operating System Name: &#xa0;&#xa0;</td>
													 <xsl:for-each select="Log/extras/extra[logLabel='Operating System full name:']">
													 <td><xsl:value-of select="logValue"/></td>
													 </xsl:for-each>
									 </tr>
									 <tr><td>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									         &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									 				 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0; Operating System Version: &#xa0;&#xa0;</td>
													 <xsl:for-each select="Log/extras/extra[logLabel='Operating Sytem version:']">
													 <td><xsl:value-of select="logValue"/></td>
													 </xsl:for-each>
									 </tr>
									 <tr><td>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									         &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									 				 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0; Memory Total: &#xa0;&#xa0;</td>
													 <xsl:for-each select="Log/extras/extra[logLabel='Memory Total :']">
													 <td><xsl:value-of select="logValue"/></td>
													 </xsl:for-each>
									 </tr>
									 <tr><td>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									         &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									 				 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0; Memory Available: &#xa0;&#xa0;</td>
													 <xsl:for-each select="Log/extras/extra[logLabel='Memory Available :']">
													 <td><xsl:value-of select="logValue"/></td>
													 </xsl:for-each>
									 </tr>
									 <tr><td>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									 				 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
													 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0; Browser: &#xa0;&#xa0;</td>
													 <xsl:for-each select="Log/extras/extra[logLabel='Browser :']">
													 <td><xsl:value-of select="logValue"/></td>
													 </xsl:for-each>
									 </tr>
									 <tr><td>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									 				 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
													 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0; OS Lang Code: &#xa0;&#xa0;</td>
													 <xsl:for-each select="Log/extras/extra[logLabel='OS Lang Code:']">
													 <td><xsl:value-of select="logValue"/></td>
													 </xsl:for-each>
									 </tr>
				</table>
				</div>
				<div id="PTFEnvInfo" style="DISPLAY: none">
				<table align="left" border="0" cellspacing="10" cellpadding="0">
							 		 <br></br>
									 <pre><br></br></pre>
							 		 <tr><td>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									 			   &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
													 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0; PTF Environment :&#xa0;&#xa0;</td>
													 <xsl:for-each select="Log/extras/extra[logLabel='Env. URL :']">
													 <td><xsl:value-of select="logValue"/></td>
													 </xsl:for-each>
									 </tr>
									 <tr><td>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
									 			   &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
													 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0; PsTestFramework Version:&#xa0;&#xa0;</td>
													 <xsl:for-each select="Log/extras/extra[logLabel='PsTestFramework Version :']">
													 <td><xsl:value-of select="logValue"/></td>
													 </xsl:for-each>
									 </tr>
				</table>
				</div>
				<div id="StepwiseInfo" style="DISPLAY:inline">
				<br></br>
				<xsl:variable name="countLogLine">
					 <xsl:value-of select="count(Log/lines/logLine)"/>
				</xsl:variable>
				<a id="ExpLink" href="javascript:showLogExpand({$countLogLine});" title="Expand All Rows" style="display:inline">Expand All</a>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
				<a id="ColLink" href="javascript:showLogCollapse({$countLogLine});" title="Collapse All Rows" style="display:inline">Collapse All</a>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
				<pre></pre>
				<xsl:for-each select="Log/lines/logLine">
				<table id="StepLog" height="100%" border="0" cellspacing="0" cellpadding="0">
							<tr id="msgLog{logLineID}" style="DISPLAY:">
							 		 		 				<td>
															<img id="expandImg{logLineID}" src="\static\Logs_Maker\r-arrow.png" onclick="javascript:showLog('{logLineID}')" title="Expand" width="12" height="12" style="DISPLAY:"></img>
															<img id="collapseImg{logLineID}" src="\static\Logs_Maker\d-arrow.png" onclick="javascript:hideLog('{logLineID}')" title="Collapse" width="12" height="12" style="DISPLAY: none"></img>&#xa0;&#xa0;
															</td>
															<xsl:if test="logResult='LogFatalError' or logResult='121'">
													 					<td><img src="\static\Logs_Maker\FatalError.jpg" title="Fatal Error" width="20" height="18"></img></td>
															</xsl:if>
															<xsl:if test="logResult='LogFail' or logResult='120'">
													 					<td><img src="\static\Logs_Maker\Fail.jpg" title="Fail" width="20" height="20"></img></td>
															</xsl:if>
															<xsl:if test="logResult='LogInfo' or logResult='102'">
													 					<td><img src="\static\Logs_Maker\Info.jpg" title="Info" width="20" height="20"></img></td>
															</xsl:if>
															<xsl:if test="logResult='LogPass' or logResult='110'">
													 					<td><img src="\static\Logs_Maker\Pass.jpg" title="Pass" width="20" height="20"></img></td>
															</xsl:if>
															<xsl:if test="logResult='LogNone' or logResult='100'">
													 					<td><img src="\static\Logs_Maker\None.jpg" title="None" width="20" height="20"></img></td>
															</xsl:if>
															<xsl:if test="logResult='LogWarning' or logResult='115'">
													 					<td><img src="\static\Logs_Maker\None.jpg" title="Warning" width="20" height="20"></img></td>
															</xsl:if>
															<xsl:if test="logResult='LogScreenShot'or logResult='220'">
													 					<td><img src="\static\Logs_Maker\Screenshot.jpg" title="ScreenShot" width="20" height="20"></img></td>
															</xsl:if>
															<td>
															Message:&#xa0;</td>
															<td>
															<xsl:choose>
																 <xsl:when test="logResult='LogScreenShot' or logResult='220'">
																 		<a id="scrshoturl" href="javascript:screenshoturl('{logLineID}')" title="Go to view ScreenShot" style="display:inline">Screenshot</a>&#xa0;&#xa0;
																		<p style="display:inline">If the screen shot doesn't appear, you can find the Image with the Test Name suffixed with Line<xsl:value-of select="logLineID"/> in the same folder where this XML resides</p>
																 </xsl:when>
																 <xsl:otherwise>
																 		<xsl:value-of select="lineMessage"/>
																 </xsl:otherwise>		
														  </xsl:choose>
															</td>
										</tr>
									 <tr id="exprLog{logLineID}" style="DISPLAY:none">
									 		 <td colspan="2"></td>
											 <td>Expression:</td>
											 <td><xsl:value-of select="commandExpression"/></td>
									 </tr>
									 <tr id="detailLog{logLineID}" style="DISPLAY:none">
									 		 <td colspan="2"></td>
											 <td>Details:</td>
											 <xsl:choose>
											 <xsl:when test="lineMessage='Goto URL'">
											 	<td><a id="gotoURL" href="javascript:openPIA('{longDescr}')" title="Go to Application"><xsl:value-of select="longDescr"/></a></td>
											 </xsl:when>
											 <xsl:otherwise>
											 	<td><xsl:value-of select="longDescr"/></td>
											 </xsl:otherwise>
											 </xsl:choose>
									 </tr>
									 <tr id="calledLog{logLineID}" style="DISPLAY:none">
									 		 <td colspan="2"></td>
											 <td>Called Test:&#xa0;</td>
											 <td><xsl:value-of select="libraryName"/></td>
							 		 </tr>
									 <tr id="commandID{logLineID}" style="DISPLAY:none">
									 		 <td colspan="2"></td>
											 <td>Command ID:&#xa0;</td>
											 <td><xsl:value-of select="commandID"/></td>
							 		 </tr>
				 </table>
				 </xsl:for-each>
				</div>
		</td> 
	</tr>
</table>
</body>
</html>
</xsl:template>
</xsl:stylesheet>
