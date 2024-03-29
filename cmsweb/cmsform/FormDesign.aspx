<%@ Import Namespace="Unionsoft.Platform"%>
<%@ Page Language="vb" AutoEventWireup="false" Inherits="Unionsoft.Cms.Web.FormDesign" validateRequest="false" CodeFile="FormDesign.aspx.vb" enableEventValidation="false"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>窗体设计</title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="Visual Basic .NET 7.1" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<LINK href="/cmsweb/css/cmsstyle.css" type="text/css" rel="stylesheet">
		<SCRIPT language="JavaScript" src="/cmsweb/script/jscommon.js"></SCRIPT>
		<script language="JavaScript">
<!--
/*
	代码说明：
	－、下面代码中的"xx"、"yy"是为移动元素所需的2个动态属性，分别记录移动前的X和Y坐标。
	－、主元素(主选择元素)：第一个选中的元素；次元素(次选择元素)：第二个开始选中的所有元素
*/

var IsDesignChanged=false
var IsDraging=false //判断是否处于拖动状态中
var xMouseBefMove, yMouseBefMove //移动元素前的鼠标X、Y坐标
var currentSelMainElement //当前选中的主元素（第一个选中的元素）
var currentDot //当前正移动(正改变主选择元素宽度高度)的定位点
var saveSign //保存类型：save, saveas
var arrElments = new Array() //保存所有次选择元素（第二个开始选中的元素）
var arrDots = new Array() //保存所有次选择元素的定位点

var g_pointSelTimes = 0; //多选控件时判断第几次点击
var g_pointStartX = 0; //多选控件的起点
var g_pointStartY = 0; //多选控件的起点
var g_pointEndX = 0; //多选控件的终点
var g_pointEndY = 0; //多选控件的终点

document.onmousedown=EvtMouseDown //定义鼠标点击的事件入口
document.onmouseup=EvtMouseUp //定义鼠标放开的事件入口
document.onkeydown=EvtKeyDown //定义键盘点击的事件入口
document.onmouseover=EvtMouseOver //定义鼠标移至的事件入口

//添加元素
function AddElement(){
	try{
		IsDesignChanged=true
		//获取选择的字段
		var selIndex = document.all.item("ListBox1").selectedIndex;
		if (selIndex == -1){
			alert("请选择合适的字段！");
			return;
		}
		var ctlDispName = document.all.item("ListBox1").options(selIndex).text;
		var valType = GetCtrlValType(document.all.item("ListBox1").options(selIndex).value)
		var ctlName = GetCtrlName(document.all.item("ListBox1").options(selIndex).value)
		
		//创建Text元素
		var blnCreateLabel = 1;
		if (valType == "1"){ //选择项
			var ctlText1 = document.createElement("<SELECT ctrltype='ddlist' ctrlscript='' ctrlreadonly='0' ctrlbitian='0' dragSign='frmElement' id='" + ctlName + "' name='" + ctlName + "' style='Z-INDEX: 125; POSITION: absolute; HEIGHT: 20px; WIDTH: 90px;TOP:5px;LEFT:97px'> <OPTION selected></OPTION></SELECT>");
			panelForm.appendChild(ctlText1);
		}else if (valType == "101"){ //是输入窗体设计中的多媒体型
			//创建文件上传控件元素
			var ctlFile1 = document.createElement("<INPUT ctrltype='image' ctrlscript='' ctrlreadonly='0' ctrlbitian='0' type='file' id='" + ctlName + "' name='" + ctlName + "' dragSign='fileElement' disabled style='Z-INDEX: 103; POSITION: absolute; LEFT: 97px; TOP: 5px; WIDTH: 222px'>");
			panelForm.appendChild(ctlFile1);
		}else if (valType == "102"){ //是打印窗体设计中的多媒体型
			var ctlImg1 = document.createElement("<IMG border=0 ctrltype='image' ctrlscript='' ctrlreadonly='0' ctrlbitian='0' id='" + ctlName + "' name='" + ctlName + "' dragSign='frmElement'  style='Z-INDEX: 125; LEFT: 97px; POSITION: absolute; TOP: 5px; HEIGHT:80px; WIDTH:80px' alt='图片'>");
			panelForm.appendChild(ctlImg1);
		}else if (valType == "100"){ //是打印窗体设计中的所有元素显示为Label
			var ctlLabel1 = document.createElement("<label ctrltype='TextboxInPrint' ctrlscript='' ctrlreadonly='0' ctrlbitian='0' dragSign='frmElement' align='left' id='" + ctlName + "' name='" + ctlName + "' value='[" + ctlDispName + "]' style='POSITION: absolute; HEIGHT: 20px; WIDTH: 90px;top:9px;left:97px '></label>");
			ctlLabel1.innerText = "[" + ctlDispName + "]";
			panelForm.appendChild(ctlLabel1);
		}else if (valType == "11"){ //多选一选择项
			var ctlText1 = document.createElement("<input ctrltype='radio' ctrlscript='' ctrlreadonly='0' ctrlbitian='0' dragSign='frmElement' id='" + ctlName + "' name='" + ctlName + "' value='[" + ctlDispName + "]' readonly style='POSITION: absolute; HEIGHT: 45px; WIDTH: 400px;top:5px;left:97px'>");
			panelForm.appendChild(ctlText1);
			blnCreateLabel = 0; //不显示Label
		}else if (valType == "13"){ //目录文件
			var ctlFile1 = document.createElement("<INPUT ctrltype='fileForDirFile' ctrlscript='' ctrlreadonly='0' ctrlbitian='0' type='file' id='" + ctlName + "' name='" + ctlName + "' dragSign='fileElement' disabled style='Z-INDEX: 103; POSITION: absolute; LEFT: 97px; TOP: 5px; WIDTH: 222px'>");
			panelForm.appendChild(ctlFile1);
		}
		else if(valType == "201"){	//是HTML编辑器 @guoja
			var ctlText1 = document.createElement("<input ctrltype='html' ctrlscript='' ctrlreadonly='0' ctrlbitian='0' dragSign='frmElement' id='" + ctlName + "' name='" + ctlName + "' value='[" + ctlDispName + "]' readonly style='POSITION: absolute; HEIGHT: 20px; WIDTH: 90px;top:5px;left:97px'>");
			panelForm.appendChild(ctlText1);
		}else if (valType == "12"){ //是否选择项
			var ctlText1 = document.createElement("<input ctrltype='checkgrp' ctrlscript='' ctrlreadonly='0' ctrlbitian='0' dragSign='frmElement' id='" + ctlName + "' name='" + ctlName + "' type='checkbox' disabled value='[" + ctlDispName + "]' style='POSITION: absolute; HEIGHT: 20px; WIDTH: 200px;top:5px;left:97px'>");
			panelForm.appendChild(ctlText1);
			blnCreateLabel = 0; //不显示Label
		}else{ //if (valType == "0"){ //是输入型
			var ctlText1 = document.createElement("<input ctrltype='text' ctrlscript='' ctrlreadonly='0' ctrlbitian='0' dragSign='frmElement' id='" + ctlName + "' name='" + ctlName + "' value='[" + ctlDispName + "]' readonly style='POSITION: absolute; HEIGHT: 20px; WIDTH: 90px;top:5px;left:97px'>");
			panelForm.appendChild(ctlText1);
		}

		//创建Label元素
		if (blnCreateLabel==1){
		    //var lblName = "lbl" + ctlName;
		    var lblName = "lbl_" + Math.round(Math.random() * 10000000000); // + "_" + ctlName;
		    var strAlign = "right";
		    if (self.document.forms(0).formtype.value == 1){
		        strAlign = "left";
		    }
		    var ctlLabel1 = document.createElement("<label ctrltype='label' ctrlscript='' ctrlreadonly='0' ctrlbitian='0' dragSign='frmElement' align='right' id='" + lblName + "' name='" + lblName + "' style='POSITION: absolute; HEIGHT: 20px; WIDTH: 56px;top:9px;left:32px;TEXT-ALIGN: " + strAlign + "'></label>");
		    ctlLabel1.innerText = ctlDispName;
		    panelForm.appendChild(ctlLabel1);
		}
	}catch(ex){
	}
}

//获取窗体内所有元素的布局信息
function GetDFormLayout(){
	//获取窗体本身布局信息
	var ctlInfo = ";;" + "1||" + "FORM_CONTAINER" + "||0||||" + panelForm.style.left + "||" + panelForm.style.top + "||" + panelForm.style.pixelWidth + "||" + panelForm.style.pixelHeight + "||||;;";

	//获取窗体内所有元素的布局信息
	for (var i = 0; i < panelForm.all.length; i++){	
		var ctlItem = panelForm.all.item(i);
		var intHeight = ctlItem.style.pixelHeight;
		if (ctlItem.style.display != "none" && ctlItem.name != null){ //不保存隐藏的元素
		
			if (ctlItem.ctrltype == "label"){
				//2: 表示是标签Label
				ctlInfo = ctlInfo + "2||" + ctlItem.name + "||0||" + ctlItem.innerText + "||" + ctlItem.style.left + "||" + ctlItem.style.top + "||" + ctlItem.style.pixelWidth + "||" + intHeight + "||" + ctlItem.style.textAlign + "||||";
				ctlInfo = ctlInfo + ctlItem.style.fontFamily + "||" + ctlItem.style.fontSize + "||" + ctlItem.style.color + "||" + ctlItem.style.fontWeight + "||" + ctlItem.style.fontStyle + "||" + ctlItem.style.textDecoration + "||";
				
				ctlInfo=ctlInfo + "||" + ctlItem.style.border +"," + ctlItem.style.borderBottom +"," + ctlItem.style.borderTop +"," + ctlItem.style.borderRight +"," + ctlItem.style.borderLeft + "||;;";
			}
			
			else if (ctlItem.ctrltype == "TextboxInPrint"){
				//14: 所有元素在打印窗体中都显示为Label
				ctlInfo = ctlInfo + "14||" + ctlItem.name + "||0||" + ctlItem.innerText + "||" + ctlItem.style.left + "||" + ctlItem.style.top + "||" + ctlItem.style.pixelWidth + "||" + intHeight + "||" + ctlItem.style.textAlign + "||||";
				ctlInfo = ctlInfo + ctlItem.style.fontFamily + "||" + ctlItem.style.fontSize + "||" + ctlItem.style.color + "||" + ctlItem.style.fontWeight + "||" + ctlItem.style.fontStyle + "||" + ctlItem.style.textDecoration + "||";
				ctlInfo=ctlInfo + "||" + ctlItem.style.border +"," + ctlItem.style.borderBottom +"," + ctlItem.style.borderTop +"," + ctlItem.style.borderRight +"," + ctlItem.style.borderLeft + "||;;";
			}
			
			else if (ctlItem.ctrltype == "text"){
				//3: 表示是输入型元素（如Text）
				var ctlName = ctlItem.value
				ctlInfo = ctlInfo + "3||" + ctlItem.name + "||" + ctlItem.ctrlreadonly + "||" + ctlName + "||" + ctlItem.style.left + "||" + ctlItem.style.top + "||" + ctlItem.style.pixelWidth + "||" + intHeight + "||" + ctlItem.style.textAlign + "||||";
				ctlInfo = ctlInfo + ctlItem.style.fontFamily + "||" + ctlItem.style.fontSize + "||" + ctlItem.style.color + "||" + ctlItem.style.fontWeight + "||" + ctlItem.style.fontStyle + "||" + ctlItem.style.textDecoration + "||" + ctlItem.ctrlbitian + "||";
				ctlInfo = ctlInfo+ ctlItem.style.border +"," + ctlItem.style.borderBottom +"," + ctlItem.style.borderTop +"," + ctlItem.style.borderRight +"," + ctlItem.style.borderLeft + "||;;";
			}			
			
			else if (ctlItem.ctrltype == "image"){
				//4: 表示是Image图形控件
				ctlInfo = ctlInfo + "4||" + ctlItem.name + "||0||" + ctlItem.src + "||" + ctlItem.style.left + "||" + ctlItem.style.top + "||" + ctlItem.style.pixelWidth + "||" + intHeight + "||" + "||||;;";
			}else if (ctlItem.ctrltype == "pageimg"){
				//13: 表示是页面上的图形文件
				ctlInfo = ctlInfo + "13||" + ctlItem.name + "||0||" + ctlItem.src + "||" + ctlItem.style.left + "||" + ctlItem.style.top + "||" + ctlItem.style.pixelWidth + "||" + intHeight + "||" + "||||;;";
			//}else if (ctlItem.ctrltype == "imagefile"){
			//	//4: 表示是Image图形控件
			//	ctlInfo = ctlInfo + "4||" + ctlItem.name + "||" + ctlItem.ctrlreadonly + "||" + ctlItem.src + "||" + ctlItem.style.left + "||" + ctlItem.style.top + "||" + ctlItem.style.pixelWidth + "||" + intHeight + "||" + "||||;;";
			}else if (ctlItem.ctrltype == "imageForBinCol"){
				//15: 二进制字段以图片方式显示
				ctlInfo = ctlInfo + "15||" + ctlItem.name + "||0||" + ctlItem.src + "||" + ctlItem.style.left + "||" + ctlItem.style.top + "||" + ctlItem.style.pixelWidth + "||" + intHeight + "||" + "||||;;";
			}else if (ctlItem.ctrltype == "fileForDirFile"){
				//18: 目录文件的文件控件
				ctlInfo = ctlInfo + "18||" + ctlItem.name + "||0||" + ctlItem.src + "||" + ctlItem.style.left + "||" + ctlItem.style.top + "||" + ctlItem.style.pixelWidth + "||" + intHeight + "||" + "||||;;";
			}else if (ctlItem.ctrltype == "imageForDirFile"){
				//17: 目录文件的图片显示
				ctlInfo = ctlInfo + "17||" + ctlItem.name + "||0||" + ctlItem.src + "||" + ctlItem.style.left + "||" + ctlItem.style.top + "||" + ctlItem.style.pixelWidth + "||" + intHeight + "||" + "||||;;";
			}else if (ctlItem.ctrltype == "imageForUrlCol"){
				//16: 二进制字段以图片方式显示
				ctlInfo = ctlInfo + "16||" + ctlItem.name + "||0||" + ctlItem.src + "||" + ctlItem.style.left + "||" + ctlItem.style.top + "||" + ctlItem.style.pixelWidth + "||" + intHeight + "||" + "||||;;";
			}
			
			else if (ctlItem.ctrltype == "file"){
				//5: 表示是File控件，文件上传控件
				ctlInfo = ctlInfo + "5||" + ctlItem.name + "||" + ctlItem.ctrlreadonly + "||" + ctlItem.value + "||" + ctlItem.style.left + "||" + ctlItem.style.top + "||" + ctlItem.style.pixelWidth + "||||" + "||||";
				ctlInfo = ctlInfo + "||||||||||||||" + ctlItem.style.border +"," + ctlItem.style.borderBottom +"," + ctlItem.style.borderTop +"," + ctlItem.style.borderRight +"," + ctlItem.style.borderLeft + "||;;";
			}
			
			else if (ctlItem.ctrltype == "ddlist"){
				//6: 表示是DropDownList
				var ctlName = ctlItem.value
				ctlInfo = ctlInfo + "6||" + ctlItem.name + "||" + ctlItem.ctrlreadonly + "||" + ctlName + "||" + ctlItem.style.left + "||" + ctlItem.style.top + "||" + ctlItem.style.pixelWidth + "||" + intHeight + "||" + ctlItem.style.textAlign + "||||";
				ctlInfo = ctlInfo + ctlItem.style.fontFamily + "||" + ctlItem.style.fontSize + "||" + ctlItem.style.color + "||" + ctlItem.style.fontWeight + "||" + ctlItem.style.fontStyle + "||" + ctlItem.style.textDecoration + "||" + ctlItem.ctrlbitian + "||;;";
			}
			
			else if (ctlItem.ctrltype == "line"){
				//7: 表示是Line控件
				ctlInfo = ctlInfo + "7||" + ctlItem.name + "||0||" + "线条" + "||" + ctlItem.style.left + "||" + ctlItem.style.top + "||" + ctlItem.style.pixelWidth + "||" + intHeight + "||" + "||||";
				ctlInfo = ctlInfo + "||||||||||||||" + "||" + ctlItem.style.backgroundColor + ";;";
			}
			
			else if (ctlItem.ctrltype == "ResTable"){
				//8: 表示是资源表单控件
				ctlInfo = ctlInfo + "8||" + ctlItem.name + "||0||" + ctlItem.tabresid + "||" + ctlItem.style.left + "||" + ctlItem.style.top + "||" + ctlItem.style.pixelWidth + "||" + intHeight + "||" + "||||;;";
			}
			
			else if (ctlItem.ctrltype == "cmsbtn"){
				//9: 表示是普通按钮
				ctlInfo = ctlInfo + "9||" + ctlItem.name + "||0||" + ctlItem.value + "||" + ctlItem.style.left + "||" + ctlItem.style.top + "||" + ctlItem.style.pixelWidth + "||" + intHeight + "||" + "||" + ctlItem.ctrlscript + "||";
				ctlInfo = ctlInfo + "||||||||||||||" + ctlItem.style.border +"," + ctlItem.style.borderBottom +"," + ctlItem.style.borderTop +"," + ctlItem.style.borderRight +"," + ctlItem.style.borderLeft + "||;;";
			}
			
			else if (ctlItem.ctrltype == "linkbtn"){
				//10: 表示是普通链接
				if (ctlItem.innerText != ""){
					ctlInfo = ctlInfo + "10||" + ctlItem.name + "||0||" + ctlItem.innerText + "||" + ctlItem.style.left + "||" + ctlItem.style.top + "||" + ctlItem.style.pixelWidth + "||" + intHeight + "||" + "||" + ctlItem.ctrlscript + "||;;";
				}else{
					ctlInfo = ctlInfo + "10||" + ctlItem.name + "||0||" + ctlItem.value + "||" + ctlItem.style.left + "||" + ctlItem.style.top + "||" + ctlItem.style.pixelWidth + "||" + intHeight + "||" + "||" + ctlItem.ctrlscript + "||";
				}
				ctlInfo = ctlInfo + "||||||||||||||" + ctlItem.style.border +"," + ctlItem.style.borderBottom +"," + ctlItem.style.borderTop +"," + ctlItem.style.borderRight +"," + ctlItem.style.borderLeft + "||;;";
			}
			
			else if (ctlItem.ctrltype == "radio"){
				//11: 表示是多选一选择项
				var ctlName = ctlItem.value
				ctlInfo = ctlInfo + "11||" + ctlItem.name + "||" + ctlItem.ctrlreadonly + "||" + ctlName + "||" + ctlItem.style.left + "||" + ctlItem.style.top + "||" + ctlItem.style.pixelWidth + "||" + intHeight + "||" + ctlItem.style.textAlign + "||||";
				ctlInfo = ctlInfo + ctlItem.style.fontFamily + "||" + ctlItem.style.fontSize + "||" + ctlItem.style.color + "||" + ctlItem.style.fontWeight + "||" + ctlItem.style.fontStyle + "||" + ctlItem.style.textDecoration + "||" + ctlItem.ctrlbitian + "||";
				ctlInfo = ctlInfo+ ctlItem.style.border +"," + ctlItem.style.borderBottom +"," + ctlItem.style.borderTop +"," + ctlItem.style.borderRight +"," + ctlItem.style.borderLeft + "||;;";
			}
			
			else if (ctlItem.ctrltype == "checkgrp"){
				//12: 表示是是否选择项
				var ctlName = ctlItem.value
				ctlInfo = ctlInfo + "12||" + ctlItem.name + "||" + ctlItem.ctrlreadonly + "||" + ctlName + "||" + ctlItem.style.left + "||" + ctlItem.style.top + "||" + ctlItem.style.pixelWidth + "||" + intHeight + "||" + ctlItem.style.textAlign + "||||";
				ctlInfo = ctlInfo + ctlItem.style.fontFamily + "||" + ctlItem.style.fontSize + "||" + ctlItem.style.color + "||" + ctlItem.style.fontWeight + "||" + ctlItem.style.fontStyle + "||" + ctlItem.style.textDecoration + "||" + ctlItem.ctrlbitian + "||";
				ctlInfo = ctlInfo+ ctlItem.style.border +"," + ctlItem.style.borderBottom +"," + ctlItem.style.borderTop +"," + ctlItem.style.borderRight +"," + ctlItem.style.borderLeft + "||;;";
			}else if(ctlItem.ctrltype == "html"){
				//HTML编辑器	'guoja
				var ctlName = ctlItem.value
				ctlInfo = ctlInfo + "20||" + ctlItem.name + "||" + ctlItem.ctrlreadonly + "||" + ctlName + "||" + ctlItem.style.left + "||" + ctlItem.style.top + "||" + ctlItem.style.pixelWidth + "||" + intHeight + "||" + ctlItem.style.textAlign + "||||";
				ctlInfo = ctlInfo + ctlItem.style.fontFamily + "||" + ctlItem.style.fontSize + "||" + ctlItem.style.color + "||" + ctlItem.style.fontWeight + "||" + ctlItem.style.fontStyle + "||" + ctlItem.style.textDecoration + "||" + ctlItem.ctrlbitian + "||;;";
				
			}else{
				//未知元素
			}
		}
	}
	
	return ctlInfo;
}

//解析字段值类型
function GetCtrlValType(optValue){
	var strTemp = new String(optValue);
	var pos = strTemp.indexOf ("]", 0) 
	return strTemp.substring(1, pos)
}

//解析字段名称
function GetCtrlName(optValue){
	var strTemp = new String(optValue);
	var pos = strTemp.indexOf ("]", 0);
	var curResID;
	var relRes = document.all.item("ddlHostTables")
	if (relRes == null){
		curResID = getUrlParam("mnuresid");
	}else{
		curResID = relRes.options(relRes.selectedIndex).value;
		if(curResID == ""){
			relRes = document.all.item("ddlSubTables")
			curResID = relRes.options(relRes.selectedIndex).value;
		}else{
		}
	}
	return "TAB" + curResID + "___" + strTemp.substring(pos+1);
}

function DoNothing(){
	return false;
}

//元素水平对齐
function AlignHorizontal(){
	IsDesignChanged=true
	try{
		//先计算需要对齐的高度位置，如果第一个选择的控件是Label，则高度-4，因为Label比Textbox低4个像素
		var posTop;
		if (currentSelMainElement.ctrltype == "label"){
			posTop = parseInt(currentSelMainElement.style.pixelTop) - 4;
		}else if (currentSelMainElement.ctrltype == "text"){
			posTop = parseInt(currentSelMainElement.style.pixelTop);
		}else if (currentSelMainElement.ctrltype == "image"){
			posTop = parseInt(currentSelMainElement.style.pixelTop);
		}else if (currentSelMainElement.ctrltype == "pageimg"){
			posTop = parseInt(currentSelMainElement.style.pixelTop);
		}else if (currentSelMainElement.ctrltype == "imageForBinCol"){
			posTop = parseInt(currentSelMainElement.style.pixelTop);
		}else if (currentSelMainElement.ctrltype == "imageForDirFile"){
			posTop = parseInt(currentSelMainElement.style.pixelTop);
		}else if (currentSelMainElement.ctrltype == "imageForUrlCol"){
			posTop = parseInt(currentSelMainElement.style.pixelTop);
		}else if (currentSelMainElement.ctrltype == "fileForDirFile"){
			posTop = parseInt(currentSelMainElement.style.pixelTop);
		//}else if (currentSelMainElement.ctrltype == "imagefile"){
		//	posTop = parseInt(currentSelMainElement.style.pixelTop);
		}else if (currentSelMainElement.ctrltype == "file"){
			posTop = parseInt(currentSelMainElement.style.pixelTop);
		}else if (currentSelMainElement.ctrltype == "ddlist"){
			posTop = parseInt(currentSelMainElement.style.pixelTop);
		}else if (currentSelMainElement.ctrltype == "TextboxInPrint"){
			posTop = parseInt(currentSelMainElement.style.pixelTop);
		}else if (currentSelMainElement.ctrltype == "radio"){
			posTop = parseInt(currentSelMainElement.style.pixelTop);
		}else if (currentSelMainElement.ctrltype == "checkgrp"){
			posTop = parseInt(currentSelMainElement.style.pixelTop);
		}else if (currentSelMainElement.ctrltype == "ResTable"){
			posTop = parseInt(currentSelMainElement.style.pixelTop);
		}else if (currentSelMainElement.ctrltype == "line"){
			posTop = parseInt(currentSelMainElement.style.pixelTop);
		}else if (currentSelMainElement.ctrltype == "cmsbtn"){
			posTop = parseInt(currentSelMainElement.style.pixelTop);
		}else if (currentSelMainElement.ctrltype == "linkbtn"){
			posTop = parseInt(currentSelMainElement.style.pixelTop);
		}

		//对齐指定类型的控件
		for (var i=0; i<arrElments.length; i++){
			if (arrElments[i].ctrltype == "label"){
				arrElments[i].style.pixelTop=posTop + 4;
			}else if (arrElments[i].ctrltype == "text"){
				arrElments[i].style.pixelTop=posTop;
			}else if (arrElments[i].ctrltype == "image"){
				arrElments[i].style.pixelTop=posTop;
			}else if (arrElments[i].ctrltype == "pageimg"){
				arrElments[i].style.pixelTop=posTop;
			}else if (arrElments[i].ctrltype == "imageForBinCol"){
				arrElments[i].style.pixelTop=posTop;
			}else if (arrElments[i].ctrltype == "imageForDirFile"){
				arrElments[i].style.pixelTop=posTop;
			}else if (arrElments[i].ctrltype == "imageForUrlCol"){
				arrElments[i].style.pixelTop=posTop;
			}else if (arrElments[i].ctrltype == "fileForDirFile"){
				arrElments[i].style.pixelTop=posTop;
			//}else if (arrElments[i].ctrltype == "imagefile"){
			//	arrElments[i].style.pixelTop=posTop;
			}else if (arrElments[i].ctrltype == "file"){
				arrElments[i].style.pixelTop=posTop;
			}else if (arrElments[i].ctrltype == "ddlist"){
				arrElments[i].style.pixelTop=posTop;
			}else if (arrElments[i].ctrltype == "TextboxInPrint"){
				arrElments[i].style.pixelTop=posTop;
			}else if (arrElments[i].ctrltype == "radio"){
				arrElments[i].style.pixelTop=posTop;
			}else if (arrElments[i].ctrltype == "checkgrp"){
				arrElments[i].style.pixelTop=posTop;
			}else if (arrElments[i].ctrltype == "ResTable"){
				arrElments[i].style.pixelTop=posTop;
			}else if (arrElments[i].ctrltype == "line"){
				arrElments[i].style.pixelTop=posTop;
			}else if (arrElments[i].ctrltype == "cmsbtn"){
				arrElments[i].style.pixelTop=posTop;
			}else if (arrElments[i].ctrltype == "linkbtn"){
				arrElments[i].style.pixelTop=posTop;
			}
		}
	}catch(ex){
	}

	/* 
	清除所有选中元素相关的参数
	将来改进：不清除所有选中元素相关的参数，但是需要同时移动所有定位点，以便于用户对齐后的一起移动操作
	*/
	//Hide4Dots(); //隐藏主元素的4个定位点
	//DeleteDynamicAddedDots(); //移除动态添加显示的定位点
	//ClearSelElementArray(); //移除所有元素的选择，其实是从全局数组中移除
}

//元素左对齐
function AlignLeft(){
	IsDesignChanged=true
	try{
		var pos = parseInt(currentSelMainElement.style.pixelLeft);
		for (var i=0; i<arrElments.length; i++){
			arrElments[i].style.pixelLeft=pos;
		}
	}catch(ex){
	}

	/* 
	清除所有选中元素相关的参数
	将来改进：不清除所有选中元素相关的参数，但是需要同时移动所有定位点，以便于用户对齐后的一起移动操作
	*/
	//Hide4Dots(); //隐藏主元素的4个定位点
	//DeleteDynamicAddedDots(); //移除动态添加显示的定位点
	//ClearSelElementArray(); //移除所有元素的选择，其实是从全局数组中移除
}

//元素右对齐
function AlignRight(){
	IsDesignChanged=true
	try{
		var pos = parseInt(currentSelMainElement.style.pixelLeft) + parseInt(currentSelMainElement.style.pixelWidth);
		for (var i=0; i<arrElments.length; i++){
			arrElments[i].style.pixelLeft=pos - parseInt(arrElments[i].style.pixelWidth)
		}
	}catch(ex){
	}

	/* 
	清除所有选中元素相关的参数
	将来改进：不清除所有选中元素相关的参数，但是需要同时移动所有定位点，以便于用户对齐后的一起移动操作
	*/
	//Hide4Dots(); //隐藏主元素的4个定位点
	//DeleteDynamicAddedDots(); //移除动态添加显示的定位点
	//ClearSelElementArray(); //移除所有元素的选择，其实是从全局数组中移除
}

//宽度对齐
function AlignWidth(){
	IsDesignChanged=true
	try{
		var pos = parseInt(currentSelMainElement.style.pixelWidth);
		for (var i=0; i<arrElments.length; i++){
			arrElments[i].style.pixelWidth=pos;
		}
	}catch(ex){
	}

	/* 
	清除所有选中元素相关的参数
	将来改进：不清除所有选中元素相关的参数，但是需要同时移动所有定位点，以便于用户对齐后的一起移动操作
	*/
	//Hide4Dots(); //隐藏主元素的4个定位点
	//DeleteDynamicAddedDots(); //移除动态添加显示的定位点
	//ClearSelElementArray(); //移除所有元素的选择，其实是从全局数组中移除
}

//高度对齐
function AlignHeight(){
	IsDesignChanged=true
	try{
		var pos = parseInt(currentSelMainElement.style.pixelHeight);
		if (pos<=0){
			pos = 20; //有些元素无法获取高度，默认为20pixel
		}
		for (var i=0; i<arrElments.length; i++){
			arrElments[i].style.pixelHeight=pos;
		}
	}catch(ex){
	}

	/* 
	清除所有选中元素相关的参数
	将来改进：不清除所有选中元素相关的参数，但是需要同时移动所有定位点，以便于用户对齐后的一起移动操作
	*/
	//Hide4Dots(); //隐藏主元素的4个定位点
	//DeleteDynamicAddedDots(); //移除动态添加显示的定位点
	//ClearSelElementArray(); //移除所有元素的选择，其实是从全局数组中移除
}

//元素内部文字左对齐
function TextAlignLeft(){
	IsDesignChanged=true
	try{
		if (currentSelMainElement != null){
			currentSelMainElement.style.textAlign = "left"
		}
		for (var i=0; i<arrElments.length; i++){
			arrElments[i].style.textAlign = "left"
		}
	}catch(ex){
	}
}

//元素内部文字右对齐
function TextAlignRight(){
	IsDesignChanged=true
	try{
		if (currentSelMainElement != null){
			currentSelMainElement.style.textAlign = "right"
		}
		for (var i=0; i<arrElments.length; i++){
			arrElments[i].style.textAlign = "right"
		}
	}catch(ex){
	}
}

//元素内部文字居中对齐
function TextAlignCenter(){
	IsDesignChanged=true
	try{
		if (currentSelMainElement != null){
			currentSelMainElement.style.textAlign = "center"
		}
		for (var i=0; i<arrElments.length; i++){
			arrElments[i].style.textAlign = "center"
		}
	}catch(ex){
	}
}

//鼠标Over事件入口
function EvtMouseOver(){
	try{
		if (event.srcElement.dragSign=="frmElement"){
			event.srcElement.style.cursor = "move"; //鼠标移至元素上时显示“鼠标移动”标志
		}
	}catch(ex){
	}
}

//键盘击键的事件响应入口
function EvtKeyDown(){
	try{
		if (event.keyCode == 46){ //键盘Del键
			IsDesignChanged=true
			DeleteElement();
		}
	}catch(ex){
	}
}

//放开鼠标的事件入口
function EvtMouseUp(){
	try{
		if (IsDraging == false){
			return;
		}
		
		IsDraging=false
		
		//定位主选择元素
		currentSelMainElement.xx = currentSelMainElement.style.pixelLeft
		currentSelMainElement.yy = currentSelMainElement.style.pixelTop

		//定位主选择元素的4个定位点
		frmInputDesign.left_mid.xx = frmInputDesign.left_mid.style.pixelLeft
		frmInputDesign.left_mid.yy = frmInputDesign.left_mid.style.pixelTop
		frmInputDesign.middle_top.xx = frmInputDesign.middle_top.style.pixelLeft
		frmInputDesign.middle_top.yy = frmInputDesign.middle_top.style.pixelTop
		frmInputDesign.middle_bot.xx = frmInputDesign.middle_bot.style.pixelLeft
		frmInputDesign.middle_bot.yy = frmInputDesign.middle_bot.style.pixelTop
		frmInputDesign.right_mid.xx = frmInputDesign.right_mid.style.pixelLeft
		frmInputDesign.right_mid.yy = frmInputDesign.right_mid.style.pixelTop

		//定位所有次选择元素	
		for (var i=0; i < arrElments.length; i++){
			arrElments[i].xx = arrElments[i].style.pixelLeft
			arrElments[i].yy = arrElments[i].style.pixelTop
		}

		//定位所有次选择元素的定位点	
		for (var i=0; i < arrDots.length; i++){
			arrDots[i].xx = arrDots[i].style.pixelLeft
			arrDots[i].yy = arrDots[i].style.pixelTop
		}

		//显示当前选中的元素的位置
		if (currentSelMainElement != null){
			document.all.item("lblStatus1").innerText = "元素宽:" + currentSelMainElement.style.pixelWidth + " 高:" + currentSelMainElement.style.pixelHeight + " x:" + currentSelMainElement.style.pixelLeft + " y:" + currentSelMainElement.style.pixelTop
		}
	}catch(ex){
	}
}

//添加标签元素
function AddElementLabel(){
	IsDesignChanged=true
	var lblValue = window.prompt("请输入标签显示内容：", "");
	if (lblValue == null){
		return; //用户点击了“取消”
	}

	var ctlName = "lbl" + Math.round(Math.random() * 10000000000);
	var ctlLabel1 = document.createElement("<label ctrltype='label' ctrlscript='' ctrlreadonly='0' ctrlbitian='0' id='" + ctlName + "' name='" + ctlName + "' dragSign='frmElement' readonly style='POSITION: absolute; HEIGHT: 20px; WIDTH: 65px;top:5px;left:97px '></label>");
	ctlLabel1.innerText = lblValue;
	panelForm.appendChild(ctlLabel1);
	return false;
}

//添加"文件上传控件"元素
function AddElementFile(){
	IsDesignChanged=true;
	var ctlName = "CmsFile" + Math.round(Math.random() * 10000000000);
	var ctlFile1 = document.createElement("<INPUT ctrltype='file' ctrlscript='' ctrlreadonly='0' ctrlbitian='0' type='file' id='" + ctlName + "' name='" + ctlName + "' dragSign='fileElement' disabled style='Z-INDEX: 103; POSITION: absolute; LEFT: 97px; TOP: 5px; WIDTH: 222px'>");
	panelForm.appendChild(ctlFile1);
	return true;
}

function AddElementButton(){
	IsDesignChanged=true
	var btnValue = window.prompt("请输入按钮名称：", "");
	if (btnValue == null){
		return; //用户点击了“取消”
	}

	var ctlName = "cmsbtn" + Math.round(Math.random() * 10000000000);
	var ctlBtn = document.createElement("<INPUT type=button value=" + btnValue + " ctrltype='cmsbtn' ctrlscript='' ctrlreadonly='0' ctrlbitian='0' id='" + ctlName + "' name='" + ctlName + "' dragSign='frmElement' readonly style='POSITION: absolute; HEIGHT: 20px; WIDTH: 65px;top:5px;left:97px'>");
	panelForm.appendChild(ctlBtn);
	return false;
}

function AddElementLinkbtn(){
	IsDesignChanged=true
	var btnValue = window.prompt("请输入链接名称：", "");
	if (btnValue == null){
		return; //用户点击了“取消”
	}

	var ctlName = "linkbtn" + Math.round(Math.random() * 10000000000);
	var ctlBtn = document.createElement("<INPUT type=button value=" + btnValue + " ctrltype='linkbtn' ctrlscript='' ctrlreadonly='0' ctrlbitian='0' id='" + ctlName + "' name='" + ctlName + "' dragSign='frmElement' readonly style='POSITION: absolute; HEIGHT: 20px; WIDTH: 65px;top:5px;left:97px'>");
	//var ctlBtn = document.createElement("<a id='" + ctlName + "' style='POSITION: absolute; HEIGHT: 20px; WIDTH: 65px;top:5px;left:97px'>" + btnValue + "</a>");
	panelForm.appendChild(ctlBtn);
	return false;
}

function AddElementScript(){
	IsDesignChanged=true;
	try{
		if (currentSelMainElement == null){
			return false;
		}

		var rtnVal = window.showModalDialog("/cmsweb/cmsform/FormSetElementScript.aspx?ctrlscript=" + currentSelMainElement.ctrlscript, "_blank", "dialogHeight:430px; dialogWidth:580px; center;yes");
		var strRtn = new String(rtnVal);
		currentSelMainElement.ctrlscript = strRtn;
	}catch(ex){
		alert("请选择有效的控件！");
	}
}

function SetFormProperty(){
	try{
		//获取当前资源ID
		window.open("/cmsweb/cmsform/FormSetProperty.aspx?mnuresid=" + document.frmInputDesign.formresid.value + "&urlformrecid=" + document.frmInputDesign.formrecid.value + "&timeid=" + Math.round(Math.random() * 10000000000), '_blank', "left=100,top=100,height=500,width=480,status=no,toolbar=no,menubar=no,location=no,resizable=no,scrollbars=no");
	}catch(ex){
		alert("操作出错！");
	}
}

//添加元素：线条
function AddElementLine(){
	var ctlName = "line" + Math.round(Math.random() * 10000000000);
	var ctlLabel1 = document.createElement("<IMG ctrltype='line' ctrlscript='' ctrlreadonly='0' ctrlbitian='0' id='" + ctlName + "' name='" + ctlName + "' dragSign='frmElement'  style='Z-INDEX: 125; LEFT: 97px; POSITION: absolute; TOP: 5px; HEIGHT:3px; WIDTH:200px; BACKGROUND-COLOR: black' alt='' src=''>");
	panelForm.appendChild(ctlLabel1);
	return false;
}

//添加元素：图形
function AddElementImage(){
	IsDesignChanged=true
	var lblValue = window.prompt("请输入图形的WEB路径（如images/logo.gif）：", "/cmsweb/images/?.gif");
	if (lblValue == null){
		return; //用户点击了“取消”
	}
	if (lblValue == ""){
		return; //没有图形URL
	}

	var ctlName = "image_" + Math.round(Math.random() * 10000000000);
	var ctlLabel1 = document.createElement("<IMG border=0 ctrltype='pageimg' ctrlscript='' ctrlreadonly='0' ctrlbitian='0' id='" + ctlName + "' name='" + ctlName + "' dragSign='frmElement'  style='Z-INDEX: 125; LEFT: 97px; POSITION: absolute; TOP: 5px; HEIGHT:45px; WIDTH:120px' alt='" + lblValue + "' src='" + lblValue + "'>");
	panelForm.appendChild(ctlLabel1);
	return false;
}

// chenyu 2010-3-1
//添加元素：资源表单
function AddElementResTable(){
	
	IsDesignChanged=true
	var relRes = document.all.item("ddlSubTables")
	if (relRes == null){
		alert("当前版本不支持多表单窗体设计！");
		return false;
	}
	var curResName = relRes.options(relRes.selectedIndex).text;
	var curResID = relRes.options(relRes.selectedIndex).value;
	if(curResID == ""){
		alert("请选择有效的子资源！");
		return false;
	}
	var ctlName = "ResTable_" + curResID;
	var lblValue = "资源表单：" + curResName;
	
	var ctlLabel1 = document.createElement("<IMG border=0 ctrltype='ResTable' ctrlscript='' ctrlreadonly='0' ctrlbitian='0' tabresid='" + curResID + "' id='" + ctlName + "' name='" + ctlName + "' dragSign='frmElement'  style='Z-INDEX: 125; LEFT: 97px; POSITION: absolute; TOP: 5px; HEIGHT:150px; WIDTH:400px' alt='" + lblValue + "' src='" + lblValue + "'>");
	/*
	var ctlLabel1 = document.createElement("<div border=0 ctrltype='ResTable' ctrlscript='' ctrlreadonly='0' ctrlbitian='0' tabresid='" + curResID + "' id='" + ctlName + "' name='" + ctlName + "' dragSign='frmElement'  style='Z-INDEX: 125; LEFT: 97px; POSITION: absolute; TOP: 5px; HEIGHT:150px; WIDTH:400px;border:1px solid' alt='" + lblValue + "' src='" + lblValue + "' />");
	var data = Unionsoft.Cms.Web.CmsAjaxUtility.GetCmsResourceColumns(curResID).value;
	var str = "<table border=1 cellspacing=0 cellpadding=0><tr>";
	for (var j=0;j<data.Rows.length;j++)
		str = str + "<td width=" + data.Rows[j][data.Columns[4].Name] + ">" + data.Rows[j][data.Columns[0].Name] + "</td>" + "\r\n";
	str = str + "</tr></table>"
	ctlLabel1.innerHTML = str;
	*/
	
	panelForm.appendChild(ctlLabel1);
	return false;
}

//删除所有选中的元素
function DeleteElement(){
	IsDesignChanged=true
	try{
		//删除主元素
		panelForm.removeChild(currentSelMainElement);
		currentSelMainElement.style.display = "none";
		currentSelMainElement=null;

		//删除所有次元素	
		for (; arrElments.length>0; ){
			try{
				var oneElement = arrElments.shift();
				panelForm.removeChild(oneElement);
				oneElement.style.display = "none";
				oneElement=null;
			}catch(ex){
			}
		}

		Hide4Dots(); //隐藏主元素的4个定位点
		DeleteDynamicAddedDots(); //移除动态添加显示的定位点
	}catch(ex){
		alert("请选择有效的控件！");
	}
}

//设置标签内容
function SetLabelContent(){
	IsDesignChanged=true
	try{
		if (currentSelMainElement.type = "undefined"){ //"undefined": 仅对标签有用
			var lblValue = window.prompt("请输入标签显示内容：", currentSelMainElement.innerText);
			if (lblValue != null){ //只有点击“确认”才设置标签内容
				currentSelMainElement.innerText = lblValue;
			}
		}
	}catch(ex){
		alert("请选择有效的标签！");
	}
}

//将二进制字段显示为图片
function AddImageFromBinColumn(){
	try{
		IsDesignChanged=true
		//获取选择的字段
		var selIndex = document.all.item("ListBox1").selectedIndex;
		if (selIndex == -1){
			alert("请选择合适的字段！");
			return;
		}
		var ctlDispName = document.all.item("ListBox1").options(selIndex).text;
		var valType = GetCtrlValType(document.all.item("ListBox1").options(selIndex).value)
		var ctlName = GetCtrlName(document.all.item("ListBox1").options(selIndex).value)
		ctlName = "bincolimage_" + ctlName;
		
		
		if (valType == "101" || valType == "102"){ //101：是输入窗体设计中的多媒体型；102：是打印窗体设计中的多媒体型
		  var ctlImg1 = document.createElement("<IMG border=0 ctrltype='imageForBinCol' ctrlscript='' ctrlreadonly='0' ctrlbitian='0' id='" + ctlName + "' name='" + ctlName + "' dragSign='frmElement'  style='Z-INDEX: 125; LEFT: 97px; POSITION: absolute; TOP: 5px; HEIGHT:80px; WIDTH:80px' alt='图片'>");
		  panelForm.appendChild(ctlImg1);
		}else{
		  alert('操作失败，只有多媒体字段可以作为图片方式添加');
    }		 
	}catch(ex){
	}
}

//添加目录文件的图片
function AddImageFromDirFileColumn(){
	try{
		IsDesignChanged=true
		//获取选择的字段
		var selIndex = document.all.item("ListBox1").selectedIndex;
		if (selIndex == -1){
			alert("请选择合适的字段！");
			return;
		}
		var ctlDispName = document.all.item("ListBox1").options(selIndex).text;
		var ctlTip = "图片(" + ctlDispName + ")";
		var valType = GetCtrlValType(document.all.item("ListBox1").options(selIndex).value)
		var ctlName = GetCtrlName(document.all.item("ListBox1").options(selIndex).value)
		ctlName = "dirfileimage_" + ctlName;
		
		var ctlImg1 = document.createElement("<IMG border=0 ctrltype='imageForDirFile' ctrlscript='' ctrlreadonly='0' ctrlbitian='0' id='" + ctlName + "' name='" + ctlName + "' dragSign='frmElement'  style='Z-INDEX: 125; LEFT: 97px; POSITION: absolute; TOP: 5px; HEIGHT:80px; WIDTH:80px' alt='" + ctlTip + "'>");
		panelForm.appendChild(ctlImg1);
	}catch(ex){
	}
}

//将存放Url的字段显示为图片
function AddImageFromUrlColumn(){
	try{
		IsDesignChanged=true
		//获取选择的字段
		var selIndex = document.all.item("ListBox1").selectedIndex;
		if (selIndex == -1){
			alert("请选择合适的字段！");
			return;
		}
		var ctlDispName = document.all.item("ListBox1").options(selIndex).text;
		var valType = GetCtrlValType(document.all.item("ListBox1").options(selIndex).value)
		var ctlName = GetCtrlName(document.all.item("ListBox1").options(selIndex).value)
		ctlName = "urlcolimage_" + ctlName;
		
		var ctlImg1 = document.createElement("<IMG border=0 ctrltype='imageForUrlCol' ctrlscript='' ctrlreadonly='0' ctrlbitian='0' id='" + ctlName + "' name='" + ctlName + "' dragSign='frmElement'  style='Z-INDEX: 125; LEFT: 97px; POSITION: absolute; TOP: 5px; HEIGHT:80px; WIDTH:80px' alt='图片'>");
		panelForm.appendChild(ctlImg1);
	}catch(ex){
	}
}

//设置指定字段为只读
function SetCtrlReadonly(){
	IsDesignChanged=true;
	try{
		if (currentSelMainElement.ctrltype == "text" || currentSelMainElement.ctrltype == "ddlist" || currentSelMainElement.ctrltype == "radio" || currentSelMainElement.ctrltype == "checkgrp"){
			if (currentSelMainElement.ctrlreadonly == 0){
				currentSelMainElement.ctrlreadonly = 1;
				currentSelMainElement.style.color = "gray";
			}else{
				currentSelMainElement.ctrlreadonly = 0;
				currentSelMainElement.style.color = "black";
			}
		}else{
			alert("只读属性只对输入框有效！");
		}
	}catch(ex){
	}
}

//设置指定字段为必填项
function SetCtrlBitian(){
	IsDesignChanged=true;
	try{
		if (currentSelMainElement.ctrltype == "text" || currentSelMainElement.ctrltype == "ddlist" || currentSelMainElement.ctrltype == "radio" || currentSelMainElement.ctrltype == "checkgrp"){
			if (currentSelMainElement.ctrlbitian == 0){
				currentSelMainElement.ctrlbitian = 1;
				currentSelMainElement.style.backgroundColor = "red";
			}else{
				currentSelMainElement.ctrlbitian = 0;
				currentSelMainElement.style.color = "black";
				currentSelMainElement.style.backgroundColor = "";
			}
		}else{
			alert("只读属性只对输入框有效！");
		}
	}catch(ex){
	}
}

//设置字体名称
function ApplyFontInfo(){
	IsDesignChanged=true;
	try{
		if (currentSelMainElement.ctrltype == "label" || currentSelMainElement.ctrltype == "TextboxInPrint" || currentSelMainElement.ctrltype == "text" || currentSelMainElement.ctrltype == "ddlist" || currentSelMainElement.ctrltype == "radio" || currentSelMainElement.ctrltype == "checkgrp"){
			//字体名称
			var ddl = document.all.item("ddlFontName");
			currentSelMainElement.style.fontFamily = ddl.options(ddl.selectedIndex).value;

			//字体大小
			ddl = document.all.item("ddlFontSize");
			currentSelMainElement.style.fontSize = ddl.options(ddl.selectedIndex).value;

			//字体颜色
			var strColor = frmInputDesign.txtColor.value;
			
			if (strColor == ""){
				var ddl = document.all.item("ddlFontColor");
				strColor = ddl.options(ddl.selectedIndex).value;
			}
			currentSelMainElement.style.color = strColor;
			

			//粗体
			ddl = document.all.item("ddlFontBold");
			currentSelMainElement.style.fontWeight = ddl.options(ddl.selectedIndex).value;

			//斜体
			ddl = document.all.item("ddlFontItalic");
			currentSelMainElement.style.fontStyle = ddl.options(ddl.selectedIndex).value;

			//上、中、下划线
			ddl = document.all.item("ddlFontLine");
			currentSelMainElement.style.textDecoration = ddl.options(ddl.selectedIndex).value;
		}
		else if (currentSelMainElement.ctrltype=="line")
		{
			//背景颜色
			var strColor = frmInputDesign.txtColor.value;
			
			if (strColor == ""){
				var ddl = document.all.item("ddlFontColor");
				strColor = ddl.options(ddl.selectedIndex).value;
			}
			currentSelMainElement.style.backgroundColor = strColor;
		}
		else{
			alert("字体设置只对Label，Textbox，DropDownList有效！");
		}
	}catch(ex){
	}
}
//设置边框样式
function ApplyBorderInfo(){
	IsDesignChanged=true;
	try{
		if (currentSelMainElement.ctrltype == "label" || currentSelMainElement.ctrltype == "TextboxInPrint" || currentSelMainElement.ctrltype == "text" || currentSelMainElement.ctrltype == "cmsbtn" || currentSelMainElement.ctrltype == "file" || currentSelMainElement.ctrltype == "radio" || currentSelMainElement.ctrltype=="linkbtn" || currentSelMainElement.ctrltype == "checkgrp"){
			//字体名称
			var ddl = document.all.item("ddlBorderStyle");
			var ddlvalue=ddl.options(ddl.selectedIndex).value;
			
			try
			{
				//if(ddlvalue=="" || ddlvalue=="NotSet")
				//{
				//	currentSelMainElement.style.border=" 1px;";
				//}
				if (ddlvalue=="underdotted")
				{
					currentSelMainElement.style.borderTop= "0px";
					currentSelMainElement.style.borderRight= "0px";
					currentSelMainElement.style.borderLeft= "0px";
					currentSelMainElement.style.borderBottom="dotted 1px;";
					//alert(currentSelMainElement.style.borderTop + currentSelMainElement.style.borderRight + currentSelMainElement.style.borderLeft + currentSelMainElement.style.borderBottom);
				}
				else if (ddlvalue=="underdashed")
				{
					currentSelMainElement.style.borderTop= "0px";
					currentSelMainElement.style.borderRight= "0px";
					currentSelMainElement.style.borderLeft= "0px";
					currentSelMainElement.style.borderBottom= "dashed 1px;";
					
				}
				else if (ddlvalue=="undersolid")
				{
					currentSelMainElement.style.borderTop= "0px";
					currentSelMainElement.style.borderRight= "0px";
					currentSelMainElement.style.borderLeft= "0px";
					currentSelMainElement.style.borderBottom= "solid 1px;";
					
				}
				else if (ddlvalue=="underdouble")
				{
					currentSelMainElement.style.borderTop= "0px";
					currentSelMainElement.style.borderRight= "0px";
					currentSelMainElement.style.borderLeft= "0px";
					currentSelMainElement.style.borderBottom="double 1px;";
					
				}
				else
				{
					currentSelMainElement.style.border= ddlvalue +" 1px;";
					//alert(currentSelMainElement.style.border);
				}
			}
			catch(ex)
			{
				
			}
			
		}else{
			alert("字体设置只对Label,Textbox,Button,上传控件有效！");
		}
	}catch(ex){
	}
}

//增加窗体宽度
function FormWidthInc(){
	IsDesignChanged=true
	panelForm.style.pixelWidth = parseInt(panelForm.style.pixelWidth) + 10;
	document.all.item("lblFormSize").innerText = "窗体宽度：" + panelForm.style.pixelWidth + " 高度：" + panelForm.style.pixelHeight
	return false;
}

//增加窗体宽度
function FormWidthInc2(){
	IsDesignChanged=true
	panelForm.style.pixelWidth = parseInt(panelForm.style.pixelWidth) + 100;
	document.all.item("lblFormSize").innerText = "窗体宽度：" + panelForm.style.pixelWidth + " 高度：" + panelForm.style.pixelHeight
	return false;
}

//减小窗体宽度
function FormWidthDec(){
	IsDesignChanged=true
	panelForm.style.pixelWidth = parseInt(panelForm.style.pixelWidth) - 10;
	document.all.item("lblFormSize").innerText = "窗体宽度：" + panelForm.style.pixelWidth + " 高度：" + panelForm.style.pixelHeight
	return false;
}

//减小窗体宽度
function FormWidthDec2(){
	IsDesignChanged=true
	panelForm.style.pixelWidth = parseInt(panelForm.style.pixelWidth) - 100;
	document.all.item("lblFormSize").innerText = "窗体宽度：" + panelForm.style.pixelWidth + " 高度：" + panelForm.style.pixelHeight
	return false;
}

//增加窗体高度
function FormHeightInc(){
	IsDesignChanged=true
	panelForm.style.pixelHeight = parseInt(panelForm.style.pixelHeight) + 10;
	document.all.item("lblFormSize").innerText = "窗体宽度：" + panelForm.style.pixelWidth + " 高度：" + panelForm.style.pixelHeight
	return false;
}

//增加窗体高度
function FormHeightInc2(){
	IsDesignChanged=true
	panelForm.style.pixelHeight = parseInt(panelForm.style.pixelHeight) + 100;
	document.all.item("lblFormSize").innerText = "窗体宽度：" + panelForm.style.pixelWidth + " 高度：" + panelForm.style.pixelHeight
	return false;
}

//减小窗体高度
function FormHeightDec(){
	IsDesignChanged=true
	panelForm.style.pixelHeight = parseInt(panelForm.style.pixelHeight) - 10;
	document.all.item("lblFormSize").innerText = "窗体宽度：" + panelForm.style.pixelWidth + " 高度：" + panelForm.style.pixelHeight
	return false;
}

//减小窗体高度
function FormHeightDec2(){
	IsDesignChanged=true
	panelForm.style.pixelHeight = parseInt(panelForm.style.pixelHeight) - 100;
	document.all.item("lblFormSize").innerText = "窗体宽度：" + panelForm.style.pixelWidth + " 高度：" + panelForm.style.pixelHeight
	return false;
}

//隐藏主元素的4个定位点
function Hide4Dots(){
	try{
		frmInputDesign.left_mid.style.display="none";
		frmInputDesign.right_mid.style.display="none";
		frmInputDesign.middle_top.style.display="none";
		frmInputDesign.middle_bot.style.display="none";
	}catch(ex){
	}
}

/*
  鼠标左键点击的事件入口，
  如果点在元素上，则开始移动操作
  如果点在“定位点”上，则开始改变元素高度宽度的操作
*/
function EvtMouseDown(){
	if ((event.srcElement.dragSign=="frmElement")){
		g_pointSelTimes = 0;
		
		//开始移动选中的元素
		if (event.ctrlKey == true){ //CTRL键按着则继续选中元素
			Show2DynamicDotsBeforeMove(event.srcElement);
			IsDraging=false;
		}else{
			//先保留主选择的控件ID
			var oldSelElementID = "0";
			try{
				oldSelElementID = currentSelMainElement.id;
			}catch(ex){
			}
			
			//判断单前点击选中的控件是否已经在多选控件中
			var blnIsInMultiSelCtrls = 0;
			currentSelMainElement=event.srcElement;
			if (currentSelMainElement.id == oldSelElementID){
				blnIsInMultiSelCtrls=1;
			}else{
				for (var i=0; i<arrElments.length; i++){
					if (arrElments[i].id == currentSelMainElement.id){
						blnIsInMultiSelCtrls=1;
					}
				}
			}

			//设置当前主选中元素的字体信息
			SetElementFont();
			
			SetElementBorder()

			//开始移动控件
			if (blnIsInMultiSelCtrls==1){
				//点击了已经选中的控件
				Show4DotsBeforeMove(event.srcElement); //currentSelMainElement);
				IsDraging=true;
			}else{
				//点击了新的控件，则先去除所有其它选中的控件
				Hide4Dots(); //隐藏主元素的4个定位点
				DeleteDynamicAddedDots(); //移除动态添加显示的定位点
				ClearSelElementArray(); //移除所有元素的选择，其实是从全局数组中移除

				Show4DotsBeforeMove(event.srcElement); //currentSelMainElement);
				IsDraging=true;
			}
		}

		//保存选中元素在移动前的位置
		event.srcElement.xx = event.srcElement.style.pixelLeft 
		event.srcElement.yy = event.srcElement.style.pixelTop
		//保存鼠标在移动前的位置
		xMouseBefMove=event.clientX
		yMouseBefMove=event.clientY
		
		//定义鼠标移动的事件入口
		document.onmousemove=EvtMouseMove
		
		//显示当前选中的元素的位置
		if (currentSelMainElement != null){
			document.all.item("lblStatus1").innerText = "元素宽:" + currentSelMainElement.style.pixelWidth + " 高:" + currentSelMainElement.style.pixelHeight + " x:" + currentSelMainElement.style.pixelLeft + " y:" + currentSelMainElement.style.pixelTop
		}
		
		return false
	}
	
	if ((event.srcElement.dragSign=="fileElement")){
		g_pointSelTimes = 0;
		
		//开始移动选中的元素
		if (event.ctrlKey == true){ //CTRL键按着则继续选中元素
			Show2DynamicDotsBeforeMove(event.srcElement);
			IsDraging=false
		}else{
			//开始移动控件
			currentSelMainElement=event.srcElement 				
			Show2DynamicDotsBeforeMove(event.srcElement);
			IsDraging=true
		}

		//保存选中元素在移动前的位置
		event.srcElement.xx = event.srcElement.style.pixelLeft 
		event.srcElement.yy = event.srcElement.style.pixelTop
		//保存鼠标在移动前的位置
		xMouseBefMove=event.clientX
		yMouseBefMove=event.clientY
		
		//定义鼠标移动的事件入口
		document.onmousemove=EvtMouseMove
		return false
	}
	
	if (event.srcElement.dragSign=="left_mid"){
		g_pointSelTimes = 0;
		IsDraging=true
		currentDot=event.srcElement
		xMouseBefMove=event.clientX
		yMouseBefMove=event.clientY
		document.onmousemove=EvtMoveDotLeftMid
		return
	}
	
	if (event.srcElement.dragSign=="right_mid"){
		g_pointSelTimes = 0;
		IsDraging=true
		currentDot=event.srcElement
		xMouseBefMove=event.clientX
		yMouseBefMove=event.clientY
		document.onmousemove=EvtMoveDotRightMid
		return
	}
	
	if (event.srcElement.dragSign=="middle_top"){
		g_pointSelTimes = 0;
		IsDraging=true
		currentDot=event.srcElement
		xMouseBefMove=event.clientX
		yMouseBefMove=event.clientY
		document.onmousemove=EvtMoveDotMidTop
		return
	}
	
	if (event.srcElement.dragSign=="middle_bot"){
		g_pointSelTimes = 0;
		IsDraging=true
		currentDot=event.srcElement
		xMouseBefMove=event.clientX
		yMouseBefMove=event.clientY
		document.onmousemove=EvtMoveDotMidBot
		return
	}
	
	if (event.srcElement.id == "panelForm"){
		//g_pointSelTimes
		//var g_pointStart = 0; //多选控件的起点
		//var g_pointEnd = 0; //多选控件的终点
	
		if (event.altKey == true){ 
			if (g_pointSelTimes == 0){
				g_pointStartX=event.clientX - panelForm.style.pixelLeft;
				g_pointStartY=event.clientY - panelForm.style.pixelTop;
				g_pointSelTimes = g_pointSelTimes + 1;
			}else{
				//为了让滚动条滚下后仍能选中元素，这里必须加 parseInt(document.body.scrollTop)，即滚动条的TOP位置
				//g_pointEndX=event.clientX - panelForm.style.pixelLeft;
				//g_pointEndY=event.clientY - panelForm.style.pixelTop;
				g_pointEndX=parseInt(event.clientX) - parseInt(panelForm.style.pixelLeft) + parseInt(document.body.scrollLeft);
				g_pointEndY=parseInt(event.clientY) - parseInt(panelForm.style.pixelTop) + parseInt(document.body.scrollTop);
				
				//选中指定区域内的所有控件
				try{
					//alert(g_pointStartX + " " + g_pointStartY + " " + g_pointEndX + " " + g_pointEndY);
					var isFirst = 0;
					for (var i=0; i<panelForm.childNodes.length; i++){
						try{
							if (panelForm.childNodes.item(i).ctrltype == "label" || panelForm.childNodes.item(i).ctrltype == "TextboxInPrint" || panelForm.childNodes.item(i).ctrltype == "text" || panelForm.childNodes.item(i).ctrltype == "ddlist" || panelForm.childNodes.item(i).ctrltype == "radio" || panelForm.childNodes.item(i).ctrltype == "fileForDirFile" || panelForm.childNodes.item(i).ctrltype == "checkgrp"){
								//alert(panelForm.childNodes.item(i).id);
								if (panelForm.childNodes.item(i).style.pixelLeft >= g_pointStartX && panelForm.childNodes.item(i).style.pixelLeft <= g_pointEndX && panelForm.childNodes.item(i).style.pixelTop >= g_pointStartY && panelForm.childNodes.item(i).style.pixelTop <= g_pointEndY){
									//alert(panelForm.childNodes.item(i).id + " " + panelForm.childNodes.item(i).style.pixelLeft + "  " + panelForm.childNodes.item(i).style.pixelTop);
									if (isFirst == 0 && panelForm.childNodes.item(i).ctrltype == "text"){
										currentSelMainElement = panelForm.childNodes.item(i);
										Show4DotsBeforeMove(currentSelMainElement);
										isFirst = 1;
									}else{
										Show2DynamicDotsBeforeMove(panelForm.childNodes.item(i));
									}
								}
							}
						}catch(ex){
						}
					}
				}catch(ex){
					alert(ex);
				}
				
				//保存选中元素在移动前的位置
				event.srcElement.xx = event.srcElement.style.pixelLeft 
				event.srcElement.yy = event.srcElement.style.pixelTop
				//保存鼠标在移动前的位置
				xMouseBefMove=event.clientX
				yMouseBefMove=event.clientY
				
				//定义鼠标移动的事件入口
				document.onmousemove=EvtMouseMove
				IsDraging=true;
				return false
			}
		}else if (event.ctrlKey == true){ 
			//CTRL键按着则继续选中其它元素
			g_pointSelTimes = 0;
		}else{
			g_pointSelTimes = 0;
			
			Hide4Dots(); //隐藏主元素的4个定位点
			DeleteDynamicAddedDots(); //移除动态添加显示的定位点
			ClearSelElementArray(); //移除所有元素的选择，其实是从全局数组中移除
		}
	}
}

//设置当前主选中元素的字体信息
function SetElementFont(){
	var sz = currentSelMainElement.style.fontFamily;
	if (sz == ""){
		sz = "宋体"; //默认值
	}
	document.all.item("ddlFontName").value = sz;
	
	sz = new String(currentSelMainElement.style.fontSize);
	if (sz == ""){
		sz = 12; //默认值
	}else{
		sz = sz.substring(0, sz.length - 2);
	}
	document.all.item("ddlFontSize").value = sz;
	
	if (currentSelMainElement.ctrltype=="line")
	{
		sz = currentSelMainElement.style.backgroundColor;
	}
	else
	{
		sz = currentSelMainElement.style.color;
	}
	
	//sz = currentSelMainElement.style.color;
	if (sz == ""){
		document.all.item("ddlFontColor").value = "black"; //默认值
		frmInputDesign.txtColor.value = "";
	}else if (sz == "black"){
		document.all.item("ddlFontColor").value = "black";
		frmInputDesign.txtColor.value = "";
	}else if (sz == "red"){
		document.all.item("ddlFontColor").value = "red";
		frmInputDesign.txtColor.value = "";
	}else if (sz == "green"){
		document.all.item("ddlFontColor").value = "green";
		frmInputDesign.txtColor.value = "";
	}else if (sz == "blue"){
		document.all.item("ddlFontColor").value = "blue";
		frmInputDesign.txtColor.value = "";
	}else if (sz == "gray"){
		document.all.item("ddlFontColor").value = "gray";
		frmInputDesign.txtColor.value = "";
	}else{
		document.all.item("ddlFontColor").value = ""; //默认值
		frmInputDesign.txtColor.value = sz;
	}

	sz = currentSelMainElement.style.fontWeight;
	if (sz == ""){
		sz = "normal";
	}
	document.all.item("ddlFontBold").value = sz;

	sz = currentSelMainElement.style.fontStyle;
	if (sz == ""){
		sz = "normal";
	}
	document.all.item("ddlFontItalic").value = sz;

	sz = currentSelMainElement.style.textDecoration;
	if (sz == "none"){
		sz = "";
	}
	document.all.item("ddlFontLine").value = sz;
}
//设置当前主选中元素的边框样式
function SetElementBorder(){
	var border1 = currentSelMainElement.style.border;
	var border2 = currentSelMainElement.style.borderBottom;
	
        if (border1 == "" && border2 == "")
        {
            document.all.item("ddlBorderStyle").value="none";
        }
        else if (border1 != "" && border2 != "" && border1 == border2)
        {
            if (border2 == "1px")
            {
                document.all.item("ddlBorderStyle").value="none";
            }
            else
            {
                document.all.item("ddlBorderStyle").value=border2.substring(4);
            }
         }
         else if (border1=="" && border2!="")
         {
			if(border2=="1px")
			{
				document.all.item("ddlBorderStyle").value="none";
			}
			else
			{
				document.all.item("ddlBorderStyle").value="under"+border2.substring(4);
			}
         }
         else
         {
			document.all.item("ddlBorderStyle").value="none";
         }
}

//鼠标移动时同时移动选中的元素
function EvtMouseMove(){
	try{
		if (event.button==1 && IsDraging){
			IsDesignChanged=true;
			
			//获取窗体坐标
			var divLeft = parseInt(panelForm.style.pixelLeft);
			//必须减去窗体滚动条的位置，否则控件无法向上拖动
			var divTop = parseInt(panelForm.style.pixelTop) - parseInt(document.body.scrollTop); 
			var divWidth = parseInt(panelForm.style.pixelWidth);
			var divHeight = parseInt(panelForm.style.pixelHeight);
			if (divHeight <=0){
			    divHeight = 20; //有些元素无法获取高度，默认为20pixel
			}

			if (currentSelMainElement.dragSign == "fileElement"){
				//移动主选择元素
				currentSelMainElement.style.pixelLeft=currentSelMainElement.xx+event.clientX-xMouseBefMove
				currentSelMainElement.style.pixelTop=currentSelMainElement.yy+event.clientY-yMouseBefMove

				//移动所有次元素
				for (var i=0; i<arrElments.length; i++){
					arrElments[i].style.pixelLeft=arrElments[i].xx+event.clientX-xMouseBefMove
					arrElments[i].style.pixelTop=arrElments[i].yy+event.clientY-yMouseBefMove
				}

				//移动所有次元素的定位点
				for (var i=0; i<arrDots.length; i++){
					arrDots[i].style.pixelLeft=arrDots[i].xx+event.clientX-xMouseBefMove
					arrDots[i].style.pixelTop=arrDots[i].yy+event.clientY-yMouseBefMove
				}

				//显示正被移动的元素的位置
				//document.all.item("lblStatus1").innerText = "x：" + currentSelMainElement.style.pixelLeft + " y：" + currentSelMainElement.style.pixelTop
				return;
			}
			if (event.clientX >= divLeft && event.clientX <= (divLeft+divWidth) && event.clientY >= divTop && event.clientY <= (divTop + divHeight)){
				//移动主选择元素
				currentSelMainElement.style.pixelLeft=currentSelMainElement.xx+event.clientX-xMouseBefMove
				currentSelMainElement.style.pixelTop=currentSelMainElement.yy+event.clientY-yMouseBefMove
				
				
				//移动主元素的4个定位点
				Moving4DotPos()

				//移动所有次元素
				for (var i=0; i<arrElments.length; i++){
					arrElments[i].style.pixelLeft=arrElments[i].xx+event.clientX-xMouseBefMove
					arrElments[i].style.pixelTop=arrElments[i].yy+event.clientY-yMouseBefMove
				}

				//移动所有次元素的定位点
				for (var i=0; i<arrDots.length; i++){
					arrDots[i].style.pixelLeft=arrDots[i].xx+event.clientX-xMouseBefMove
					arrDots[i].style.pixelTop=arrDots[i].yy+event.clientY-yMouseBefMove
				}

				//显示当前选中的元素的位置
				if (currentSelMainElement != null){
				    var intTemp1 = currentSelMainElement.style.pixelHeight;
			        if (intTemp1 <=0){
			            intTemp1 = 20; //有些元素无法获取高度，默认为20pixel
			        }
					document.all.item("lblStatus1").innerText = "元素宽:" + currentSelMainElement.style.pixelWidth + " 高:" + intTemp1 + " x:" + currentSelMainElement.style.pixelLeft + " y:" + currentSelMainElement.style.pixelTop
				}
				return;
			}
		}
	}catch(ex){
	}
}

//左定位点的随Mouse移动
function EvtMoveDotLeftMid(){
	if (event.button==1 && IsDraging){
		IsDesignChanged=true;
		
		var selCtlWidth=parseInt(currentSelMainElement.style.pixelWidth)
		var x2=currentSelMainElement.style.pixelLeft+selCtlWidth
		if (event.clientX<(x2-6)){  
			currentDot.style.pixelLeft=currentDot.xx+event.clientX-xMouseBefMove
			currentDot.style.pixelTop=currentDot.yy+event.clientY-yMouseBefMove
			currentSelMainElement.style.pixelLeft=currentDot.xx+event.clientX-xMouseBefMove+5
			currentSelMainElement.style.pixelWidth =x2-(currentSelMainElement.style.pixelLeft)
		}
		Moving4DotPos()

		//显示当前选中的元素的位置
		if (currentSelMainElement != null){
			document.all.item("lblStatus1").innerText = "元素宽:" + currentSelMainElement.style.pixelWidth + " 高:" + currentSelMainElement.style.pixelHeight + " x:" + currentSelMainElement.style.pixelLeft + " y:" + currentSelMainElement.style.pixelTop
		}
		return false
	}
}

//右定位点的随Mouse移动
function EvtMoveDotRightMid(){
	if (event.button==1 && IsDraging){
		IsDesignChanged=true;
		
		var x2=currentSelMainElement.style.pixelLeft
		if (event.clientX>(x2+6)){  
			currentDot.style.pixelLeft=currentDot.xx+event.clientX-xMouseBefMove
			currentDot.style.pixelTop=currentDot.yy+event.clientY-yMouseBefMove
			currentSelMainElement.style.pixelWidth =(currentDot.style.pixelLeft)-x2
		}
		Moving4DotPos()

		//显示当前选中的元素的位置
		if (currentSelMainElement != null){
			document.all.item("lblStatus1").innerText = "元素宽:" + currentSelMainElement.style.pixelWidth + " 高:" + currentSelMainElement.style.pixelHeight + " x:" + currentSelMainElement.style.pixelLeft + " y:" + currentSelMainElement.style.pixelTop
		}
		return false
	}
}

//上定位点的随Mouse移动
function EvtMoveDotMidTop(){
	if (event.button==1 && IsDraging){
		IsDesignChanged=true;
		
		var selCtlHeight=parseInt(currentSelMainElement.style.pixelHeight)
	    if (selCtlHeight<=0){
	        selCtlHeight=20; //有些元素无法获取高度，默认为20pixel
	    }
		y2=currentSelMainElement.style.pixelTop+selCtlHeight
		if (event.clientY<(y2-6)){  
			currentDot.style.pixelLeft=currentDot.xx+event.clientX-xMouseBefMove
			currentDot.style.pixelTop=currentDot.yy+event.clientY-yMouseBefMove
			currentSelMainElement.style.pixelTop=currentDot.yy+event.clientY-yMouseBefMove+5
			currentSelMainElement.style.pixelHeight =y2-(currentSelMainElement.style.pixelTop)
		}
		Moving4DotPos()

		//显示当前选中的元素的位置
		if (currentSelMainElement != null){
			document.all.item("lblStatus1").innerText = "元素宽:" + currentSelMainElement.style.pixelWidth + " 高:" + currentSelMainElement.style.pixelHeight + " x:" + currentSelMainElement.style.pixelLeft + " y:" + currentSelMainElement.style.pixelTop
		}
		return false
	}
}

//下定位点的随Mouse移动
function EvtMoveDotMidBot(){
	if (event.button==1 && IsDraging){
		IsDesignChanged=true;
		
		y2=currentSelMainElement.style.pixelTop
		if (event.clientY>(y2+6)){  
			currentDot.style.pixelLeft=currentDot.xx+event.clientX-xMouseBefMove
			currentDot.style.pixelTop=currentDot.yy+event.clientY-yMouseBefMove
			currentSelMainElement.style.pixelHeight =(currentDot.style.pixelTop)-y2
		}
		Moving4DotPos()

		//显示当前选中的元素的位置
		if (currentSelMainElement != null){
			document.all.item("lblStatus1").innerText = "元素宽:" + currentSelMainElement.style.pixelWidth + " 高:" + currentSelMainElement.style.pixelHeight + " x:" + currentSelMainElement.style.pixelLeft + " y:" + currentSelMainElement.style.pixelTop
		}
		return false
	}
}

//在移动中更新主元素4个定位点的坐标
function Moving4DotPos(){
	//获取元素X、Y坐标
	var x1=currentSelMainElement.style.pixelLeft
	var y1=currentSelMainElement.style.pixelTop 
	//获取元素的高度和宽度
	var selCtlWidth=parseInt(currentSelMainElement.style.pixelWidth )
	var selCtlHeight=parseInt(currentSelMainElement.style.pixelHeight)
	if (selCtlHeight<=0){
	    selCtlHeight=20; //有些元素无法获取高度，默认为20pixel
	}

	frmInputDesign.left_mid.style.pixelLeft=x1-5
	frmInputDesign.left_mid.style.pixelTop=y1+selCtlHeight/2-3
	frmInputDesign.left_mid.style.display=""

	frmInputDesign.middle_top.style.pixelLeft=x1+selCtlWidth/2-3
	frmInputDesign.middle_top.style.pixelTop=y1-5
	frmInputDesign.middle_top.style.display=""

	frmInputDesign.middle_bot.style.pixelLeft=x1+selCtlWidth/2-3
	frmInputDesign.middle_bot.style.pixelTop=y1+selCtlHeight+1
	frmInputDesign.middle_bot.style.display=""

	frmInputDesign.right_mid.style.pixelLeft=x1+selCtlWidth
	frmInputDesign.right_mid.style.pixelTop=y1+selCtlHeight/2-3
	frmInputDesign.right_mid.style.display=""
}

//为选中的主元素显示4个定位点
function Show4DotsBeforeMove(curElement){
	//x1,y1是控件左上角的坐标
	var x1=curElement.style.pixelLeft
	var y1=curElement.style.pixelTop 
	//w,h是控件的高度和宽度
	var selCtlWidth=parseInt(curElement.style.pixelWidth)
	var selCtlHeight=parseInt(curElement.style.pixelHeight)
	if (selCtlHeight <=0){ 
	    selCtlHeight = 20; //有些元素无法获取高度，默认为20pixel
	}

	frmInputDesign.left_mid.style.pixelLeft=x1-5
	//frmInputDesign.left_mid.style.backgroundColor = 'red';
	//frmInputDesign.left_mid.style.borderColor = 'red';
	frmInputDesign.left_mid.style.pixelTop=y1+selCtlHeight/2-3		
	frmInputDesign.left_mid.style.display=""
	frmInputDesign.left_mid.xx = frmInputDesign.left_mid.style.pixelLeft
	frmInputDesign.left_mid.yy = frmInputDesign.left_mid.style.pixelTop

	frmInputDesign.middle_top.style.pixelLeft=x1+selCtlWidth/2-3
	frmInputDesign.middle_top.style.pixelTop=y1-5		
	frmInputDesign.middle_top.style.display=""
	frmInputDesign.middle_top.xx = frmInputDesign.middle_top.style.pixelLeft
	frmInputDesign.middle_top.yy = frmInputDesign.middle_top.style.pixelTop

	frmInputDesign.middle_bot.style.pixelLeft=x1+selCtlWidth/2-3
	frmInputDesign.middle_bot.style.pixelTop=y1+selCtlHeight+1		
	frmInputDesign.middle_bot.style.display=""
	frmInputDesign.middle_bot.xx = frmInputDesign.middle_bot.style.pixelLeft
	frmInputDesign.middle_bot.yy = frmInputDesign.middle_bot.style.pixelTop

	frmInputDesign.right_mid.style.pixelLeft=x1+selCtlWidth
	frmInputDesign.right_mid.style.pixelTop=y1+selCtlHeight/2-3		
	frmInputDesign.right_mid.style.display=""
	frmInputDesign.right_mid.xx = frmInputDesign.right_mid.style.pixelLeft
	frmInputDesign.right_mid.yy = frmInputDesign.right_mid.style.pixelTop
}

//为选中的次元素增加左右中部的2个定位点
function Show2DynamicDotsBeforeMove(curElement){
	//------------------------------------------------------
	//动态创建左右中间的2点，以便在选中元素上显示
	var dotName = "left_mid" + Math.round(Math.random() * 10000000000);
	var dotLeftMid = document.createElement("<IMG dragSign='left_mid' id='" + dotName + "' style='DISPLAY: none; WIDTH: 6px; POSITION: absolute; HEIGHT: 6px' height='6' src='/cmsweb/images/dot.jpg' width='6' name='" + dotName + "'>");
	panelForm.appendChild(dotLeftMid);
	arrDots.push(dotLeftMid);
	
	dotName = "right_mid" + Math.round(Math.random() * 10000000000);
	var dotRightMid = document.createElement("<IMG dragSign='right_mid' id='" + dotName + "' style='DISPLAY: none; WIDTH: 6px; POSITION: absolute; HEIGHT: 6px' height='6' src='/cmsweb/images/dot.jpg' width='6' name='" + dotName + "'>");
	panelForm.appendChild(dotRightMid);
	arrDots.push(dotRightMid);
	//------------------------------------------------------

	//------------------------------------------------------
	//获取元素坐标
	//var lastSelElement = arrElments[arrElments.length - 1]
	//var lastSelElement = event.srcElement
	var x1=curElement.style.pixelLeft
	var y1=curElement.style.pixelTop 
	//获取元素的高度和宽度
	var selCtlWidth=parseInt(curElement.style.pixelWidth)
	var selCtlHeight=parseInt(curElement.style.pixelHeight )
	if (selCtlHeight<=0){
	    selCtlHeight=20; //有些元素无法获取高度，默认为20pixel
	}

	event.srcElement.xx = curElement.style.pixelLeft
	event.srcElement.yy = curElement.style.pixelTop
	//arrElments.push(event.srcElement)
	arrElments.push(curElement)
	//------------------------------------------------------

	//------------------------------------------------------
	//定位“点”
	dotLeftMid.style.pixelLeft=x1-5
	dotLeftMid.style.pixelTop=y1+selCtlHeight/2-3		
	dotLeftMid.style.display=""
	dotLeftMid.xx = dotLeftMid.style.pixelLeft
	dotLeftMid.yy = dotLeftMid.style.pixelTop

	dotRightMid.style.pixelLeft=x1+selCtlWidth
	dotRightMid.style.pixelTop=y1+selCtlHeight/2-3		
	dotRightMid.style.display=""
	dotRightMid.xx = dotRightMid.style.pixelLeft
	dotRightMid.yy = dotRightMid.style.pixelTop
	//------------------------------------------------------
}

//移除动态添加显示的定位点
function DeleteDynamicAddedDots(){
	try{
		for (var i=0; i<1000; i++){
			if (arrDots.length <= 0){
				return;
			}
			//从数组和窗体中同时移除所有定位点
			var oneDot = arrDots.shift();
			panelForm.removeChild(oneDot);
			oneDot.style.display="none";
			oneDot = null;
		}
	}catch(ex){
	}
}

//移除所有元素的选择，其实是从全局数组中移除，但仍然显示在窗体中
function ClearSelElementArray(){
	try{
		for (var i=0; i<1000; i++){
			if (arrElments.length <= 0){
				return;
			}
			arrElments.shift();
		}
	}catch(ex){
	}
}

//跳出对话框显示已设计的窗体列表并选择
function OpenDesignedForm(){
    var rtnVal = window.showModalDialog("/cmsweb/cmsform/FormOpen.aspx?mnuresid=" + getUrlParam("mnuresid") + "&mnuformtype=" + getUrlParam("mnuformtype"), "", "dialogHeight:280px; dialogWidth:280px; center;yes"); 
    var strRtn = new String(rtnVal);
    if (strRtn.indexOf("$OPENFORM", 0) >= 0){
		//打开指定的已设计窗体
		var strFormName = strRtn.substring(10)
		if (strFormName != ""){
			document.frmInputDesign.postcmd.value = "open";
			document.frmInputDesign.formname.value = strFormName;
			document.frmInputDesign.dfrminfo.value = GetDFormLayout();
			document.frmInputDesign.submit();
		}
    }else if (strRtn.indexOf("$NEWFORM", 0) >= 0){
		//新建指定名称的窗体
		var strFormName = strRtn.substring(9)
		if (strFormName != ""){
			document.frmInputDesign.postcmd.value = "new";
			document.frmInputDesign.formname.value = strFormName;
			document.frmInputDesign.dfrminfo.value = GetDFormLayout();
			document.frmInputDesign.submit();
		}
    }else if (strRtn.indexOf("$CANCEL", 0) >= 0){
		//不做任何操作的退出
		return;
    }
}

//向服务器提交保存所有元素的布局信息
function DFormSave(){
	Hide4Dots(); //隐藏主元素的4个定位点
	DeleteDynamicAddedDots(); //移除动态添加显示的定位点

	document.frmInputDesign.dfrminfo.value = GetDFormLayout();
	//alert(document.frmInputDesign.dfrminfo.value)
	document.frmInputDesign.postcmd.value = "save";
	IsDesignChanged = false;
	document.frmInputDesign.submit();
}

//另存窗体设计信息
function DFormSaveAs(){
	var saveasFormName = window.prompt("请输入另存窗体设计的名称：", "");
	if (saveasFormName == null  || saveasFormName ==""){
	    alert('请输入窗体名称！');
		return; //用户点击了“取消”
	}

	Hide4Dots(); //隐藏主元素的4个定位点
	DeleteDynamicAddedDots(); //移除动态添加显示的定位点
//alert(saveasFormName);
	document.frmInputDesign.dfrminfo.value = GetDFormLayout();
	document.frmInputDesign.saveasname.value = saveasFormName;
	document.frmInputDesign.postcmd.value = "saveas";
	//IsDesignChanged = false;
	document.frmInputDesign.submit();
}

//另存为打印窗体
function SaveAsPrintForm(){
	Hide4Dots(); //隐藏主元素的4个定位点
	DeleteDynamicAddedDots(); //移除动态添加显示的定位点

	document.frmInputDesign.dfrminfo.value = GetDFormLayout();
	document.frmInputDesign.postcmd.value = "saveasprint";
	//IsDesignChanged = false;
	document.frmInputDesign.submit();
}

//退出，需提醒是否保存
function DoExit(){
	if (IsDesignChanged == false){ //窗体设计未改变，退出不保存
		document.frmInputDesign.postcmd.value = "exit";
		self.document.forms(0).submit();
		return;
	}
	
	var blnRtn = window.confirm("退出前是否需要保存当前窗体设计？");
	if (blnRtn == true){ //保存
		Hide4Dots(); //隐藏主元素的4个定位点
		DeleteDynamicAddedDots(); //移除动态添加显示的定位点

		document.frmInputDesign.dfrminfo.value = GetDFormLayout();
		document.frmInputDesign.saveasname.value = "";
		document.frmInputDesign.postcmd.value = "exitsave";
	}else{ //不保存
		document.frmInputDesign.postcmd.value = "exit";
	}

	self.document.forms(0).submit();
}

//当前资源的主关联资源的选择被更改
function HostRelResChanged(){
	Hide4Dots(); //隐藏主元素的4个定位点
	DeleteDynamicAddedDots(); //移除动态添加显示的定位点

	document.frmInputDesign.dfrminfo.value = GetDFormLayout();
	document.frmInputDesign.postcmd.value = "HostResChange";
	self.document.forms(0).submit();
}

//当前资源的子关联资源的选择被更改
function SubRelResChanged(){
	Hide4Dots(); //隐藏主元素的4个定位点
	DeleteDynamicAddedDots(); //移除动态添加显示的定位点

	document.frmInputDesign.dfrminfo.value = GetDFormLayout();
	document.frmInputDesign.postcmd.value = "SubResChange";
	self.document.forms(0).submit();
}

//删除当前设计窗体
function DeleteDesignedForm(){
	document.frmInputDesign.postcmd.value = "DeleteForm";
	self.document.forms(0).submit();
}
//-->
		</script>
	</HEAD>
	<body>
		<form id="frmInputDesign" method="post" runat="server">
			<input type="hidden" name="postcmd">
			<input type="hidden" name="dfrminfo">
			<input type="hidden" name="saveasname">
			<input type="hidden" name="formname" value="<%=_FormName%>">
			<input type="hidden" name="formid" value="<%=_FormId%>">
			<input type="hidden" name="formtype" value="<%=_FormType%>">
			<TABLE class="toolbar_table" style="POSITION: absolute;LEFT:1px;TOP: 1px" cellSpacing="0" border="0">
				<TR vAlign="middle">
					<TD width="4">&nbsp;</TD>
					<TD noWrap align="left"><asp:label id="lblPageTitle" runat="server"></asp:label></TD>
					<TD noWrap align="right">
						<label id="lblFormSize" style="BORDER-RIGHT: gainsboro thin solid; BORDER-TOP: gainsboro thin solid; VERTICAL-ALIGN: baseline; BORDER-LEFT: gainsboro thin solid; WIDTH: 130px; BORDER-BOTTOM: gainsboro thin solid; HEIGHT: 19px; TEXT-ALIGN: left"></label> 
						<label id="lblStatus1" style="BORDER-RIGHT: gainsboro thin solid; BORDER-TOP: gainsboro thin solid; VERTICAL-ALIGN: baseline; BORDER-LEFT: gainsboro thin solid; WIDTH: 200px; BORDER-BOTTOM: gainsboro thin solid; HEIGHT: 19px; TEXT-ALIGN: left"></label>
					</TD>
				</TR>
			</TABLE>
			<TABLE class="formdesign_toolbar" style="LEFT: 1px; POSITION: absolute; TOP: 27px" cellSpacing="0" border="0">
				<TR vAlign="middle">
					<TD noWrap align="left" width="2">&nbsp;</TD>
					<TD align="left" width="2"><IMG height="18" src="/cmsweb/images/icons/saprator.gif" width="2" align="absMiddle"></TD>
					<TD noWrap align="left" width="55"><A onclick="DFormSave()" href="#"><font color="red">保存窗体</font></A></TD>
					<TD noWrap align="left" width="30"><A onclick="DoExit()" href="#"><font color="red">退出</font></A></TD>
					<TD noWrap align="left" width="30"><A onclick="DFormSaveAs()" href="#">另存</A></TD>
					<TD noWrap align="left" width="55"><A onclick="OpenDesignedForm()" href="#">打开窗体</A></TD>
					<TD noWrap align="left" width="55"><A onclick="SetFormProperty()" href="#">窗体属性</A></TD>
					<TD align="left" width="4"><IMG height="18" src="/cmsweb/images/icons/saprator.gif" width="2" align="absMiddle"></TD>
					<TD noWrap align="left" width="55"><A onclick="DeleteDesignedForm()" href="#">删除窗体</A></TD>
					<TD noWrap align="left" width="55"><A onclick="DeleteElement()" href="#">删除元素</A></TD>
					<TD align="left" width="4"><IMG height="18" src="/cmsweb/images/icons/saprator.gif" width="2" align="absMiddle"></TD>
					<TD noWrap align="left" width="55"><A onclick="AddElementLabel()" href="#">添加标签</A></TD>
					<TD noWrap align="left" width="55"><A onclick="SetLabelContent()" href="#">修改标签</A></TD>
					<TD noWrap align="left" width="55"><A onclick="AddElementLine()" href="#">添加线条</A></TD>
					<TD noWrap align="left" width="55"><A onclick="AddElementImage()" href="#">添加图形</A></TD>
					<TD noWrap align="left" width="55"><A onclick="AddElementButton()" href="#">添加按钮</A></TD>
					<TD noWrap align="left" width="55"><A onclick="AddElementLinkbtn()" href="#">添加链接</A></TD>
					<TD noWrap align="left" width="55"><A onclick="AddElementScript()" href="#">设置脚本</A></TD>
					<TD noWrap width="100%">&nbsp;</TD>
				</TR>
			</TABLE>
			<TABLE class="formdesign_toolbar" style="LEFT: 1px; POSITION: absolute; TOP: 53px" cellSpacing="0" border="0">
				<TR vAlign="middle">
					<TD noWrap align="left" width="2">&nbsp;</TD>
					<TD align="left" width="2"><IMG height="18" src="/cmsweb/images/icons/saprator.gif" width="2" align="absMiddle"></TD>
					<TD noWrap align="left" width="70"><A onclick="AlignLeft()" href="#">元素左对齐</A></TD>
					<TD noWrap align="left" width="40"><A onclick="AlignRight()" href="#">右对齐</A></TD>
					<TD noWrap align="left" width="55"><A onclick="AlignHorizontal()" href="#">水平对齐</A></TD>
					<TD noWrap align="left" width="45"><A onclick="AlignWidth()" href="#">宽对齐</A></TD>
					<TD noWrap align="left" width="45"><A onclick="AlignHeight()" href="#">高对齐</A></TD>
					<TD align="left" width="4"><IMG height="18" src="/cmsweb/images/icons/saprator.gif" width="2" align="absMiddle"></TD>
					<TD noWrap align="left" width="70"><A onclick="TextAlignLeft()" href="#">文字左对齐</A></TD>
					<TD noWrap align="left" width="45"><A onclick="TextAlignCenter()" href="#">中对齐</A></TD>
					<TD noWrap align="left" width="45"><A onclick="TextAlignRight()" href="#">右对齐</A></TD>
					<TD align="left" width="4"><IMG height="18" src="/cmsweb/images/icons/saprator.gif" width="2" align="absMiddle"></TD>
					<TD noWrap align="left" width="60"><A onclick="FormWidthInc2()" href="#">窗体宽++</A></TD>
					<TD noWrap align="left" width="25"><A onclick="FormWidthInc()" href="#">宽+</A></TD>
					<TD noWrap align="left" width="30"><A onclick="FormWidthDec2()" href="#">宽--</A></TD>
					<TD noWrap align="left" width="25"><A onclick="FormWidthDec()" href="#">宽-</A></TD>
					<TD align="left" width="4"><IMG height="18" src="/cmsweb/images/icons/saprator.gif" width="2" align="absMiddle"></TD>
					<TD noWrap align="left" width="40"><A onclick="FormHeightInc2()" href="#">高度++</A></TD>
					<TD noWrap align="left" width="25"><A onclick="FormHeightInc()" href="#">高+</A></TD>
					<TD noWrap align="left" width="30"><A onclick="FormHeightDec2()" href="#">高--</A></TD>
					<TD noWrap align="left" width="25"><A onclick="FormHeightDec()" href="#">高-</A></TD>
					<TD noWrap width="100%">&nbsp;</TD>
				</TR>
			</TABLE>
			<TABLE class="formdesign_toolbar" style="LEFT: 1px; POSITION: absolute; TOP: 79px" cellSpacing="0" border="0">
				<TR vAlign="middle">
					<TD noWrap align="left" width="2">&nbsp;</TD>
					<TD align="left" width="2"><IMG height="18" src="/cmsweb/images/icons/saprator.gif" width="2" align="absMiddle"></TD>
					<TD noWrap align="left" width="80"><A onclick="SaveAsPrintForm()" href="#">另存打印窗体</A></TD>
					<TD noWrap align="left" width="80"><A onclick="AddElementFile()" href="#">添加文件控件</A></TD>
					<TD noWrap align="left" width="90"><A onclick="AddElementResTable()" href="#">添加子资源表单</A></TD>
					<TD noWrap align="left" width="90"><A onclick="AddImageFromBinColumn()" href="#">添加字段内图片</A></TD>
					<TD noWrap align="left" width="105"><A onclick="AddImageFromDirFileColumn()" href="#">添加目录文件图片</A></TD>
					<TD noWrap align="left" width="105"><A onclick="AddImageFromUrlColumn()" href="#">添加字段URL图片</A></TD>
					<TD noWrap align="left" width="55"><A onclick="SetCtrlReadonly()" href="#">只读属性</A></TD>
					<TD noWrap align="left" width="50"><A onclick="SetCtrlBitian()" href="#">必填项</A></TD>
					<TD align="left" width="2"><IMG height="18" src="/cmsweb/images/icons/saprator.gif" width="2" align="absMiddle">
					<TD noWrap width="100%">&nbsp;</TD>
				</TR>
			</TABLE>
			<TABLE class="formdesign_toolbar" style="LEFT: 1px; POSITION: absolute; TOP: 105px" cellSpacing="0" border="0">
				<TR vAlign="middle">
					<TD noWrap align="left" width="2">&nbsp;</TD>
					<TD align="left" width="2"><IMG height="18" src="/cmsweb/images/icons/saprator.gif" width="2" align="absMiddle"></TD>
					<TD style="WIDTH: 486px" noWrap align="left" width="486">
						<asp:dropdownlist id="ddlFontName" runat="server" Width="70px"></asp:dropdownlist>
						<asp:dropdownlist id="ddlFontSize" runat="server" Width="45px"></asp:dropdownlist>
						<asp:dropdownlist id="ddlFontBold" runat="server" Width="50px"></asp:dropdownlist>
						<asp:dropdownlist id="ddlFontItalic" runat="server" Width="50px"></asp:dropdownlist>
						<asp:dropdownlist id="ddlFontLine" runat="server" Width="60px"></asp:dropdownlist>
						<asp:dropdownlist id="ddlFontColor" runat="server" Width="50px"></asp:dropdownlist>
						<INPUT id="txtColor" type="text" maxLength="7" size="7" name="txtColor">
						<A onclick="ApplyFontInfo()" href="#">字体设置</A>
					</TD>
					<TD noWrap width="100%">
						<asp:dropdownlist id="ddlBorderStyle" runat="server"></asp:dropdownlist>
						<A onclick="ApplyBorderInfo()" href="#">边框设置</A>
					</TD>
				</TR>
			</TABLE>
			<asp:panel id="panelForm" style="LEFT: 160px; POSITION: absolute; TOP: 136px" runat="server" Width="460px" BorderWidth="1px" Height="384px">
				<IMG id="left_mid" style="DISPLAY: none; WIDTH: 6px; CURSOR: w-resize; POSITION: absolute; HEIGHT: 6px" height="6" src="/cmsweb/images/dot.jpg" width="6" name="left_mid" dragSign="left_mid">
				<IMG id="middle_top" style="DISPLAY: none; WIDTH: 6px; CURSOR: n-resize; POSITION: absolute; HEIGHT: 6px" height="6" src="/cmsweb/images/dot.jpg" width="6" name="middle_top" dragSign="middle_top">
				<IMG id="middle_bot" style="DISPLAY: none; WIDTH: 6px; CURSOR: s-resize; POSITION: absolute; HEIGHT: 6px" height="6" src="/cmsweb/images/dot.jpg" width="6" name="middle_bot" dragSign="middle_bot">
				<IMG id="right_mid" style="DISPLAY: none; WIDTH: 6px; CURSOR: e-resize; POSITION: absolute; HEIGHT: 6px" height="6" src="/cmsweb/images/dot.jpg" width="6" name="right_mid" dragSign="right_mid">
			</asp:panel>
			<asp:listbox id="ListBox1" style="LEFT: 1px; POSITION: absolute; TOP: 136px" runat="server" Width="128px" Height="340px" BackColor="Transparent"></asp:listbox>
			<IMG id="imgAddElement" style="LEFT: 136px; WIDTH: 22px; POSITION: absolute; TOP: 156px; HEIGHT: 16px" onclick="AddElement()" height="16" src="/cmsweb/images/arrow_right.gif" width="24">
			<asp:dropdownlist id="ddlSubTables" style="LEFT: 1px; POSITION: absolute; TOP: 480px" runat="server" Width="128px"></asp:dropdownlist>
		</form>
		<script language="JavaScript">
		<!--
		document.all.item("lblFormSize").innerText = "窗体宽:" + panelForm.style.pixelWidth + " 高:" + panelForm.style.pixelHeight
		-->
		</script>
	</body>
</HTML>
