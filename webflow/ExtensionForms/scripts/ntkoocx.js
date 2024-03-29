﻿var TANGER_OCX_bDocOpen = false;
var TANGER_OCX_filename;
var TANGER_OCX_actionURL; //For auto generate form fiields
var TANGER_OCX_OBJ; //The Control
var TANGER_OCX_Username="Anonymous";

//Open Document From URL
function TANGER_OCX_OpenDoc(URL)
{
	TANGER_OCX_OBJ = document.all("TANGER_OCX");
	if( (typeof(URL) != "undefined") && (URL != "") )
	{			
		TANGER_OCX_OBJ.BeginOpenFromURL(URL);
	}
	else
	{
		try{
			TANGER_OCX_OBJ.BeginOpenFromURL("default.doc");
		}
		catch(err){
			alert(err);
		}
	}
}


function TANGER_OCX_SaveEditToServerDisk(url)
{
	if(!TANGER_OCX_bDocOpen)
	{
		alert("No document opened now.");
		return false;
	}	
	TANGER_OCX_filename = document.getElementById("filename").value;
	if ( (typeof(TANGER_OCX_filename) == "undefined")||(!TANGER_OCX_filename) || (strtrim(TANGER_OCX_filename)==""))
	{
		alert("You must input a file name.");
		return false;
	}
	//var newwin,newdoc;
	try
	{
		//alert(1);
	 	if(!TANGER_OCX_doFormOnSubmit())return; //we may do onsubmit first
	 	//call SaveToURL WITOUT other form data
		var retHTML = TANGER_OCX_OBJ.SaveToURL
		(
			url,//"../common/FileWebSave.aspx",  
			"EDITFILE",	
			"", //other params seperrated by '&'. For example:myname=tanger&hisname=tom
			TANGER_OCX_filename //filename
		); //this function returns dta from server
		//alert(2);
		//document.write(retHTML);
		if (retHTML=="") 
		{
			//alert("操作成功.");
			return true;
		}
		else
		{
			//alert(retHTML);
			return false;
		}
	}
	catch(err){
		alert("err:" + err.number + ":" + err.description);
		return false;
	}
	finally{
		//return true;
	}
}

//从本地增加印章文档指定位置
function AddSignFromLocal()
{

   if(TANGER_OCX_bDocOpen)
   {
      TANGER_OCX_OBJ.AddSignFromLocal(
	TANGER_OCX_Username,//当前登陆用户
	"",//缺省文件
	true,//提示选择
	0,//left
	0)  //top
   }
}

//从URL增加印章文档指定位置
function AddSignFromURL(URL)
{
   if(TANGER_OCX_bDocOpen)
   {
      TANGER_OCX_OBJ.AddSignFromURL(
	TANGER_OCX_Username,//当前登陆用户
	URL,//URL
	50,//left
	50)  //top
   }
}

//开始手写签名
function DoHandSign()
{
   if(TANGER_OCX_bDocOpen)
   {	
	TANGER_OCX_OBJ.DoHandSign(
	TANGER_OCX_Username,//当前登陆用户 必须
	0,//笔型0－实线 0－4 //可选参数
	0x000000ff, //颜色 0x00RRGGBB//可选参数
	2,//笔宽//可选参数
	100,//left//可选参数
	50); //top//可选参数
	}
}
//检查签名结果
function DoCheckSign()
{
	if(TANGER_OCX_bDocOpen)
	{		
	var ret = TANGER_OCX_OBJ.DoCheckSign
	(
	/*可选参数 IsSilent 缺省为FAlSE，表示弹出验证对话框,否则，只是返回验证结果到返回值*/
	);//返回值，验证结果字符串
	//alert(ret);
	}	
}
function AddPictureFromLocal()
{
	if(TANGER_OCX_bDocOpen)
	{	
    TANGER_OCX_OBJ.AddPicFromLocal(
	"", //path 
	true,//prompt to select
	true,//is float
	0,//left
	0); //top
	};	
}

function AddPictureFromURL(URL)
{
	if(TANGER_OCX_bDocOpen)
	{
    TANGER_OCX_OBJ.AddPicFromURL(
	URL,//URL Note: URL must return Word supported picture types
	true,//is float
	0,//left
	0);//top
	};
}
function InsertDocFromURL(URL)
{
	if(TANGER_OCX_bDocOpen)
	{
		TANGER_OCX_OBJ.AddTemplateFromURL(URL);
	};
}


function DoHandDraw()
{
	if(TANGER_OCX_bDocOpen)
	{	
	TANGER_OCX_OBJ.DoHandDraw(
	0,// syle 0-4
	0x00ff0000,//color: 0x00RRGGBB optional
	3,//width optional
	0,//left optional
	0);//top optional
	}
}

function TANGER_OCX_AddDocHeader( strHeader )
{
	var i,cNum = 30;
	var lineStr = "";
	try
	{
		for(i=0;i<cNum;i++) lineStr += "_"; 
		with(TANGER_OCX_OBJ.ActiveDocument.Application)
		{
			Selection.HomeKey(6,0); // go home
			Selection.TypeText(strHeader);
			Selection.TypeParagraph(); 
			Selection.TypeText(lineStr); 
			Selection.TypeText("★");
			Selection.TypeText(lineStr);  
			Selection.TypeParagraph();
			Selection.HomeKey(6,1); 
			Selection.ParagraphFormat.Alignment = 1; 
			with(Selection.Font)
			{
				Name = "Arial";
				Size = 12;
				Bold = false;
				Italic = false;
				Underline = 0;
				UnderlineColor = 0;
				StrikeThrough = false;
				DoubleStrikeThrough = false;
				Outline = false;
				Emboss = false;
				Shadow = false;
				Hidden = false;
				SmallCaps = false;
				AllCaps = false;
				Color = 255;
				Engrave = false;
				Superscript = false;
				Subscript = false;
				Spacing = 0;
				Scaling = 100;
				Position = 0;
				Kerning = 0;
				Animation = 0;
				DisableCharacterSpaceGrid = false;
				EmphasisMark = 0;
			}
			Selection.MoveDown(5, 3, 0); 
		}
	}
	catch(err){
		//alert("err:" + err.number + ":" + err.description);
	}
	finally{
	}
}
function strtrim(value)
{
	return value.replace(/^\s+/,'').replace(/\s+$/,'');
}

function TANGER_OCX_doFormOnSubmit()
{
	var form = document.forms[0];
	
  	if (form.onsubmit)
	{
    	var retVal = form.onsubmit();	
     	if (typeof retVal == "boolean" && retVal == false)
       	return false;
	}

	return true;
}

//允许或禁止显示修订工具栏和工具菜单（保护修订）
function TANGER_OCX_EnableReviewBar(boolvalue)
{
	TANGER_OCX_OBJ.ActiveDocument.CommandBars("Reviewing").Enabled = boolvalue;
	TANGER_OCX_OBJ.ActiveDocument.CommandBars("Track Changes").Enabled = boolvalue;
	TANGER_OCX_OBJ.IsShowToolMenu = boolvalue;
}

//设置是否显示修改痕迹
function TANGER_OCX_SetReviewMode(boolvalue)
{
	TANGER_OCX_OBJ.ActiveDocument.TrackRevisions = boolvalue;
}

//进入或退出痕迹保留状态，调用上面的两个函数
function TANGER_OCX_SetMarkModify(boolvalue)
{
	TANGER_OCX_SetReviewMode(boolvalue);
	TANGER_OCX_EnableReviewBar(!boolvalue);
}

//显示痕迹
function TANGER_OCX_ShowRevisions(boolvalue)
{
	TANGER_OCX_OBJ.ActiveDocument.ShowRevisions = boolvalue;
}

function TANGER_OCX_PrintRevisions(boolvalue)
{
	TANGER_OCX_OBJ.ActiveDocument.PrintRevisions = boolvalue;
}

function TANGER_OCX_SetDocUser(cuser)
{
	with(TANGER_OCX_OBJ.ActiveDocument.Application)
	{
		UserName = cuser;
		TANGER_OCX_Username = cuser;
	}	
}

function TANGER_OCX_ChgLayout()
{
 	try
	{
		TANGER_OCX_OBJ.showdialog(5); 
	}
	catch(err){
		alert("err:" + err.number + ":" + err.description);
	}
	finally{
	}
}

function TANGER_OCX_PrintDoc()
{
	try
	{
		TANGER_OCX_OBJ.printout(true);
	}
	catch(err){
		alert("err:"  + err.number + ":" + err.description);
	}
	finally{
	}
}


function TANGER_OCX_EnableFileNewMenu(boolvalue)
{
	TANGER_OCX_OBJ.EnableFileCommand(0) = boolvalue;
}

function TANGER_OCX_EnableFileOpenMenu(boolvalue)
{
	TANGER_OCX_OBJ.EnableFileCommand(1) = boolvalue;
}

function TANGER_OCX_EnableFileCloseMenu(boolvalue)
{
	TANGER_OCX_OBJ.EnableFileCommand(2) = boolvalue;
}

function TANGER_OCX_EnableFileSaveMenu(boolvalue)
{
	TANGER_OCX_OBJ.EnableFileCommand(3) = boolvalue;
}

function TANGER_OCX_EnableFileSaveAsMenu(boolvalue)
{
	TANGER_OCX_OBJ.EnableFileCommand(4) = boolvalue;
}

function TANGER_OCX_EnableFilePrintMenu(boolvalue)
{
	TANGER_OCX_OBJ.EnableFileCommand(5) = boolvalue;
}

function TANGER_OCX_EnableFilePrintPreviewMenu(boolvalue)
{
	TANGER_OCX_OBJ.EnableFileCommand(6) = boolvalue;
}

function TANGER_OCX_OnDocumentOpened(str, obj)
{
	TANGER_OCX_bDocOpen = true;	
	TANGER_OCX_SetDocUser(TANGER_OCX_Username);
}

function TANGER_OCX_OnDocumentClosed()
{
   TANGER_OCX_bDocOpen = false;
}

