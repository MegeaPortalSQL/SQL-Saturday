
CREATE SCHEMA log; 
GO

/****** Object:  Table [log].[ErrorMessages]    Script Date: 28/09/2019 23:28:55 ******/

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE TABLE [log].[ErrorMessages]
([id]  [INT] IDENTITY(1, 1) NOT NULL, 
 [msg] [NVARCHAR](MAX) NULL, 
 PRIMARY KEY CLUSTERED([id] ASC)
 WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SECONDARY]
)
ON [SECONDARY] TEXTIMAGE_ON [SECONDARY];
GO

/****** Object:  Table [log].[etl_table_load_info]    Script Date: 28/09/2019 23:28:55 ******/

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE TABLE [log].[etl_table_load_info]
([id]                           [INT] IDENTITY(1, 1) NOT NULL, 
 [schema_name]                  [SYSNAME] NOT NULL, 
 [table_name]                   [SYSNAME] NOT NULL, 
 [type]                         [CHAR](1) NOT NULL, 
 [ssis_server_execution_id]     [BIGINT] NOT NULL, 
 [start_date]                   [DATETIME2](7) NOT NULL, 
 [end_date]                     [DATETIME2](7) NULL, 
 [status]                       [CHAR](1) NULL, 
 [loaded_by]                    [SYSNAME] NULL, 
 [rows]                         [BIGINT] SPARSE NULL, 
 [inserted_rows]                [INT] SPARSE NULL, 
 [updated_rows]                 [INT] SPARSE NULL, 
 [deleted_rows]                 [INT] SPARSE NULL, 
 [UpdatedRowst1]                [INT] SPARSE NULL, 
 [UpdatedRowst1h]               [INT] SPARSE NULL, 
 [UpdatedRowst2]                [INT] SPARSE NULL, 
 [$xcs]                         [XML] COLUMN_SET FOR ALL_SPARSE_COLUMNS NULL, 
 [ProjectName]                  [NVARCHAR](100) SPARSE NULL, 
 [PackageName]                  [NVARCHAR](200) SPARSE NULL, 
 [HLPId]                        [INT] SPARSE NULL, 
 [STGId]                        [INT] SPARSE NULL, 
 [DWHId]                        [INT] SPARSE NULL, 
 [DMId]                         [INT] SPARSE NULL, 
 [Parameterization]             [NVARCHAR](1000) SPARSE NULL, 
 [isOrchestrator]               [INT] SPARSE NULL, 
 [EnableExecutionControlPolicy] [BIT] SPARSE NULL, 
 [ExpirationTimeMinutes]        [INT] SPARSE NULL, 
 [RetryNumber]                  [INT] SPARSE NULL, 
 PRIMARY KEY CLUSTERED([id] ASC)
 WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SECONDARY]
)
ON [SECONDARY] TEXTIMAGE_ON [SECONDARY];
GO

/****** Object:  Table [log].[etl_test_result]    Script Date: 28/09/2019 23:28:55 ******/

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE TABLE [log].[etl_test_result]
([id]                  [INT] IDENTITY(1, 1) NOT NULL, 
 [TestName]            [NVARCHAR](100) NULL, 
 [Category]            [NVARCHAR](100) NULL, 
 [TestType]            [NVARCHAR](100) NULL, 
 [ExternalReference]   [NVARCHAR](100) NULL, 
 [CompletePath]        [NVARCHAR](1000) NULL, 
 [ActualDifferences]   [INT] NULL, 
 [MaxDifferences]      [INT] NULL, 
 [ToleranceMatrix]     [NVARCHAR](400) NULL, 
 [CurrentErrorStatus]  [TINYINT] NULL, 
 [CurrentErrorStatusdesc] AS (CASE [currentErrorStatus]
                                  WHEN(0)
                                  THEN N'Success'
                                  WHEN(1)
                                  THEN N'Warning'
                                  WHEN(2)
                                  THEN N'Error'
                                  ELSE N'Unkown'
                              END), 
 [Executed]            [TINYINT] NULL, 
 [ExpendedTimeSeconds] [INT] NULL, 
 [PerformanceTarget]   [INT] NULL, 
 [nRowsSource]         [INT] NULL, 
 [nRowsDestination]    [INT] NULL, 
 [ExecutionDate]       [DATETIME] NOT NULL, 
 PRIMARY KEY CLUSTERED([id] ASC)
 WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SECONDARY]
)
ON [SECONDARY];
GO
ALTER TABLE [log].[etl_table_load_info]
ADD CONSTRAINT [DF__loaded_by] DEFAULT(SUSER_SNAME()) FOR [loaded_by];
GO
ALTER TABLE [log].[etl_test_result]
ADD DEFAULT(GETDATE()) FOR [ExecutionDate];
GO
ALTER TABLE [log].[etl_table_load_info]
WITH CHECK
ADD CONSTRAINT [CK__table_load_info__status] CHECK(([status] = 'F'
                                                    OR [status] = 'S'
                                                    OR [status] = 'C'));
GO
ALTER TABLE [log].[etl_table_load_info] CHECK CONSTRAINT [CK__table_load_info__status];
GO
ALTER TABLE [log].[etl_table_load_info]
WITH CHECK
ADD CONSTRAINT [CK__table_load_info__type] CHECK(([type] = 'F'
                                                  OR [type] = 'I'
                                                  OR [type] = 'D'
                                                  OR [type] = 'M'));
GO
ALTER TABLE [log].[etl_table_load_info] CHECK CONSTRAINT [CK__table_load_info__type];
GO
GO

/****** Object:  StoredProcedure [dbo].[OrderDateErrors]    Script Date: 28/09/2019 23:29:52 ******/

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE [dbo].[OrderDateErrors] @ErrorMsg NVARCHAR(MAX)
AS
    BEGIN
        INSERT INTO log.ErrorMessages(msg)
    VALUES(@ErrorMsg);
    END;
GO