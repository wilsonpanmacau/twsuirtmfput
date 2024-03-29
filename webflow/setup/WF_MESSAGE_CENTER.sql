CREATE TABLE [dbo].[WF_MESSAGE_CENTER] (
	[Id] [int] IDENTITY (1, 1) NOT NULL ,
	[Type] [nvarchar] (10) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[WorklistItemId] [nvarchar] (50) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[EmployeeCode] [nvarchar] (50) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[EmployeeName] [nvarchar] (50) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[Destination] [nvarchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[Subject] [nvarchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[Content] [nvarchar] (2000) COLLATE Chinese_PRC_CI_AS NULL ,
	[State] [smallint] NULL ,
	[CreateDate] [datetime] NULL ,
	[SendDate] [datetime] NULL ,
	CONSTRAINT [PK_WF_MESSAGE_CENTER] PRIMARY KEY  CLUSTERED 
	(
		[Id]
	)  ON [PRIMARY] 
) ON [PRIMARY]


