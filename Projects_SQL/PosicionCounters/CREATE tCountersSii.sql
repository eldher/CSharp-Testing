
USE [Exchange]
GO

/****** Object:  Table [dbo].[tCountersSII]    Script Date: 05/13/2014 16:16:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tCountersSii](
	[fecha] [int] NOT NULL,
	[codagencia] [int] NOT NULL,
	[Umonto_43_1] [money] NOT NULL,
	[Utasa_43_1] [money] NOT NULL,
	[Uoper_43_1] [money] NOT NULL,
	[Umonto_44_1] [money] NOT NULL,
	[Utasa_44_1] [money] NOT NULL,
	[Uoper_44_1] [money] NOT NULL,
	[Umonto_43_2] [money] NOT NULL,
	[Utasa_43_2] [money] NOT NULL,
	[Uoper_43_2] [money] NOT NULL,
	[Umonto_44_2] [money] NOT NULL,
	[Utasa_44_2] [money] NOT NULL,
	[Uoper_44_2] [money] NOT NULL,
	[Umonto_11_2] [money] NOT NULL,
	[Utasa_11_2] [money] NOT NULL,
	[Uoper_11_2] [money] NOT NULL,
	[Umonto_55_2] [money] NOT NULL,
	[Utasa_55_2] [money] NOT NULL,
	[Uoper_55_2] [money] NOT NULL,
	[Umonto_67_67] [money] NOT NULL,
	[Utasa_67_67] [money] NOT NULL,
	[Uoper_67_67] [money] NOT NULL,
	[Umonto_66_66] [money] NOT NULL,
	[Utasa_66_66] [money] NOT NULL,
	[Uoper_66_66] [money] NOT NULL,
	[Umonto_49_3] [money] NOT NULL,
	[Utasa_49_3] [money] NOT NULL,
	[Uoper_49_3] [money] NOT NULL,
	[Umonto_56_3] [money] NOT NULL,
	[Utasa_56_3] [money] NOT NULL,
	[Uoper_56_3] [money] NOT NULL,
	[Umonto_87_8] [money] NOT NULL,
	[Utasa_87_8] [money] NOT NULL,
	[Uoper_87_8] [money] NOT NULL,
	[Umonto_92_9] [money] NOT NULL,
	[Utasa_92_9] [money] NOT NULL,
	[Uoper_92_9] [money] NOT NULL,
	[Umonto_93_10] [money] NOT NULL,
	[Utasa_93_10] [money] NOT NULL,
	[Uoper_93_10] [money] NOT NULL,
	[Umonto_94_11] [money] NOT NULL,
	[Utasa_94_11] [money] NOT NULL,
	[Uoper_94_11] [money] NOT NULL,
	[Umonto_33_15] [money] NOT NULL,
	[Utasa_33_15] [money] NOT NULL,
	[Uoper_33_15] [money] NOT NULL,
	[Umonto_34_16] [money] NOT NULL,
	[Utasa_34_16] [money] NOT NULL,
	[Uoper_34_16] [money] NOT NULL,
	[Dmonto_43_1] [money] NOT NULL,
	[Dtasa_43_1] [money] NOT NULL,
	[Doper_43_1] [money] NOT NULL,
	[Dmonto_44_1] [money] NOT NULL,
	[Dtasa_44_1] [money] NOT NULL,
	[Doper_44_1] [money] NOT NULL,
	[Dmonto_43_2] [money] NOT NULL,
	[Dtasa_43_2] [money] NOT NULL,
	[Doper_43_2] [money] NOT NULL,
	[Dmonto_44_2] [money] NOT NULL,
	[Dtasa_44_2] [money] NOT NULL,
	[Doper_44_2] [money] NOT NULL,
	[Dmonto_11_2] [money] NOT NULL,
	[Dtasa_11_2] [money] NOT NULL,
	[Doper_11_2] [money] NOT NULL,
	[Dmonto_55_2] [money] NOT NULL,
	[Dtasa_55_2] [money] NOT NULL,
	[Doper_55_2] [money] NOT NULL,
	[Dmonto_49_3] [money] NOT NULL,
	[Dtasa_49_3] [money] NOT NULL,
	[Doper_49_3] [money] NOT NULL,
	[Dmonto_56_3] [money] NOT NULL,
	[Dtasa_56_3] [money] NOT NULL,
	[Doper_56_3] [money] NOT NULL,
	[Dmonto_92_9] [money] NOT NULL,
	[Dtasa_92_9] [money] NOT NULL,
	[Doper_92_9] [money] NOT NULL,
	[Dmonto_93_10] [money] NOT NULL,
	[Dtasa_93_10] [money] NOT NULL,
	[Doper_93_10] [money] NOT NULL,
	[Dmonto_94_11] [money] NOT NULL,
	[Dtasa_94_11] [money] NOT NULL,
	[Doper_94_11] [money] NOT NULL,
	[CCmonto] [money] NOT NULL,
	[CCtasa] [money] NOT NULL,
	[CCoper] [money] NOT NULL,
	[CVmonto] [money] NOT NULL,
	[CVtasa] [money] NOT NULL,
	[CVoper] [money] NOT NULL,
	[CPCmonto] [money] NOT NULL,
	[CPCoper] [money] NOT NULL,
	[CPVmonto] [money] NOT NULL,
	[CPVoper] [money] NOT NULL,
	[CICmonto] [money] NOT NULL,
	[CICoper] [money] NOT NULL,
	[CIVmonto] [money] NOT NULL,
	[CIVoper] [money] NOT NULL,
	[CCHmonto] [money] NOT NULL,
	[CHCmonto] [money] NOT NULL,
	[EBs] [money] NOT NULL,
	[EUSD] [money] NOT NULL,
	[ECity] [money] NOT NULL,
	[EThom] [money] NOT NULL,
	[EVisa] [money] NOT NULL,
	[EAmex] [money] NOT NULL,
	[lasttime] [datetime] NULL,
	[Umonto_62_2] [money] NOT NULL,
	[Utasa_62_2] [money] NOT NULL,
	[Uoper_62_2] [money] NOT NULL,
	[Umonto_62_2_C] [money] NOT NULL,
	[Utasa_62_2_C] [money] NOT NULL,
	[Uoper_62_2_C] [money] NOT NULL,
	[chcmontod] [money] NOT NULL,
	[eeur] [money] NOT NULL,
	[EThomeur] [money] NOT NULL,
	[EAmexeur] [money] NOT NULL,
	[ethomd] [money] NOT NULL,
	[evisad] [money] NOT NULL,
	[valesbs] [money] NOT NULL,
	[valesusd] [money] NOT NULL,
	[valesdiv] [money] NOT NULL,
	[Umonto_43_12] [money] NOT NULL,
	[Utasa_43_12] [money] NOT NULL,
	[Uoper_43_12] [money] NOT NULL,
	[Umonto_44_12] [money] NOT NULL,
	[Utasa_44_12] [money] NOT NULL,
	[Uoper_44_12] [money] NOT NULL,
	[Dmonto_43_12] [money] NOT NULL,
	[Dtasa_43_12] [money] NOT NULL,
	[Doper_43_12] [money] NOT NULL,
	[Dmonto_44_12] [money] NOT NULL,
	[Dtasa_44_12] [money] NOT NULL,
	[Doper_44_12] [money] NOT NULL,
	[edivisa] [money] NOT NULL,
	[eamexd] [money] NOT NULL,
	[emonto_43_2] [money] NOT NULL,
	[etasa_43_2] [money] NOT NULL,
	[eoper_43_2] [money] NOT NULL,
	[emonto_44_2] [money] NOT NULL,
	[etasa_44_2] [money] NOT NULL,
	[eoper_44_2] [money] NOT NULL,
	[chctasa] [money] NOT NULL,
	[chcoper] [money] NOT NULL,
	[chctasad] [money] NOT NULL,
	[chcoperd] [money] NOT NULL,
	[chcmontoe] [money] NOT NULL,
	[chctasae] [money] NOT NULL,
	[chcopere] [money] NOT NULL,
	[Dmonto_562_12] [money] NOT NULL,
	[Dtasa_562_12] [money] NOT NULL,
	[Doper_562_12] [money] NOT NULL,
	[umonto_562_12] [money] NOT NULL,
	[utasa_562_12] [money] NOT NULL,
	[uoper_562_12] [money] NOT NULL,
 CONSTRAINT [PK_tCountersSii] PRIMARY KEY NONCLUSTERED 
(
	[fecha] ASC,
	[codagencia] ASC
)
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Umonto__3DE82FB7]  DEFAULT (0) FOR [Umonto_43_1]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Utasa___3EDC53F0]  DEFAULT (0) FOR [Utasa_43_1]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Uoper___3FD07829]  DEFAULT (0) FOR [Uoper_43_1]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Umonto__40C49C62]  DEFAULT (0) FOR [Umonto_44_1]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Utasa___41B8C09B]  DEFAULT (0) FOR [Utasa_44_1]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Uoper___42ACE4D4]  DEFAULT (0) FOR [Uoper_44_1]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Umonto__43A1090D]  DEFAULT (0) FOR [Umonto_43_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Utasa___44952D46]  DEFAULT (0) FOR [Utasa_43_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Uoper___4589517F]  DEFAULT (0) FOR [Uoper_43_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Umonto__467D75B8]  DEFAULT (0) FOR [Umonto_44_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Utasa___477199F1]  DEFAULT (0) FOR [Utasa_44_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Uoper___4865BE2A]  DEFAULT (0) FOR [Uoper_44_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Umonto__4959E263]  DEFAULT (0) FOR [Umonto_11_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Utasa___4A4E069C]  DEFAULT (0) FOR [Utasa_11_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Uoper___4B422AD5]  DEFAULT (0) FOR [Uoper_11_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Umonto__4C364F0E]  DEFAULT (0) FOR [Umonto_55_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Utasa___4D2A7347]  DEFAULT (0) FOR [Utasa_55_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Uoper___4E1E9780]  DEFAULT (0) FOR [Uoper_55_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Umonto__4F12BBB9]  DEFAULT (0) FOR [Umonto_67_67]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Utasa___5006DFF2]  DEFAULT (0) FOR [Utasa_67_67]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Uoper___50FB042B]  DEFAULT (0) FOR [Uoper_67_67]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Umonto__51EF2864]  DEFAULT (0) FOR [Umonto_66_66]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Utasa___52E34C9D]  DEFAULT (0) FOR [Utasa_66_66]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Uoper___53D770D6]  DEFAULT (0) FOR [Uoper_66_66]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Umonto__54CB950F]  DEFAULT (0) FOR [Umonto_49_3]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Utasa___55BFB948]  DEFAULT (0) FOR [Utasa_49_3]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Uoper___56B3DD81]  DEFAULT (0) FOR [Uoper_49_3]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Umonto__57A801BA]  DEFAULT (0) FOR [Umonto_56_3]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Utasa___589C25F3]  DEFAULT (0) FOR [Utasa_56_3]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Uoper___59904A2C]  DEFAULT (0) FOR [Uoper_56_3]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Umonto__5A846E65]  DEFAULT (0) FOR [Umonto_87_8]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Utasa___5B78929E]  DEFAULT (0) FOR [Utasa_87_8]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Uoper___5C6CB6D7]  DEFAULT (0) FOR [Uoper_87_8]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Umonto__5D60DB10]  DEFAULT (0) FOR [Umonto_92_9]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Utasa___5E54FF49]  DEFAULT (0) FOR [Utasa_92_9]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Uoper___5F492382]  DEFAULT (0) FOR [Uoper_92_9]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Umonto__603D47BB]  DEFAULT (0) FOR [Umonto_93_10]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Utasa___61316BF4]  DEFAULT (0) FOR [Utasa_93_10]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Uoper___6225902D]  DEFAULT (0) FOR [Uoper_93_10]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Umonto__6319B466]  DEFAULT (0) FOR [Umonto_94_11]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Utasa___640DD89F]  DEFAULT (0) FOR [Utasa_94_11]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Uoper___6501FCD8]  DEFAULT (0) FOR [Uoper_94_11]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Umonto__65F62111]  DEFAULT (0) FOR [Umonto_33_15]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Utasa___66EA454A]  DEFAULT (0) FOR [Utasa_33_15]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Uoper___67DE6983]  DEFAULT (0) FOR [Uoper_33_15]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Umonto__68D28DBC]  DEFAULT (0) FOR [Umonto_34_16]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Utasa___69C6B1F5]  DEFAULT (0) FOR [Utasa_34_16]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Uoper___6ABAD62E]  DEFAULT (0) FOR [Uoper_34_16]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Dmonto__6BAEFA67]  DEFAULT (0) FOR [Dmonto_43_1]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Dtasa___6CA31EA0]  DEFAULT (0) FOR [Dtasa_43_1]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Doper___6D9742D9]  DEFAULT (0) FOR [Doper_43_1]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Dmonto__6E8B6712]  DEFAULT (0) FOR [Dmonto_44_1]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Dtasa___6F7F8B4B]  DEFAULT (0) FOR [Dtasa_44_1]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Doper___7073AF84]  DEFAULT (0) FOR [Doper_44_1]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Dmonto__7167D3BD]  DEFAULT (0) FOR [Dmonto_43_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Dtasa___725BF7F6]  DEFAULT (0) FOR [Dtasa_43_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Doper___73501C2F]  DEFAULT (0) FOR [Doper_43_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Dmonto__74444068]  DEFAULT (0) FOR [Dmonto_44_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Dtasa___753864A1]  DEFAULT (0) FOR [Dtasa_44_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Doper___762C88DA]  DEFAULT (0) FOR [Doper_44_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Dmonto__7720AD13]  DEFAULT (0) FOR [Dmonto_11_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Dtasa___7814D14C]  DEFAULT (0) FOR [Dtasa_11_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Doper___7908F585]  DEFAULT (0) FOR [Doper_11_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Dmonto__79FD19BE]  DEFAULT (0) FOR [Dmonto_55_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Dtasa___7AF13DF7]  DEFAULT (0) FOR [Dtasa_55_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Doper___7BE56230]  DEFAULT (0) FOR [Doper_55_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Dmonto__7CD98669]  DEFAULT (0) FOR [Dmonto_49_3]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Dtasa___7DCDAAA2]  DEFAULT (0) FOR [Dtasa_49_3]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Doper___7EC1CEDB]  DEFAULT (0) FOR [Doper_49_3]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Dmonto__7FB5F314]  DEFAULT (0) FOR [Dmonto_56_3]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Dtasa___00AA174D]  DEFAULT (0) FOR [Dtasa_56_3]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Doper___019E3B86]  DEFAULT (0) FOR [Doper_56_3]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Dmonto__02925FBF]  DEFAULT (0) FOR [Dmonto_92_9]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Dtasa___038683F8]  DEFAULT (0) FOR [Dtasa_92_9]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Doper___047AA831]  DEFAULT (0) FOR [Doper_92_9]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Dmonto__056ECC6A]  DEFAULT (0) FOR [Dmonto_93_10]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Dtasa___0662F0A3]  DEFAULT (0) FOR [Dtasa_93_10]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Doper___075714DC]  DEFAULT (0) FOR [Doper_93_10]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Dmonto__084B3915]  DEFAULT (0) FOR [Dmonto_94_11]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Dtasa___093F5D4E]  DEFAULT (0) FOR [Dtasa_94_11]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Doper___0A338187]  DEFAULT (0) FOR [Doper_94_11]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__CCmont__0B27A5C0]  DEFAULT (0) FOR [CCmonto]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__CCtasa__0C1BC9F9]  DEFAULT (0) FOR [CCtasa]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__CCoper__0D0FEE32]  DEFAULT (0) FOR [CCoper]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__CVmont__0E04126B]  DEFAULT (0) FOR [CVmonto]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__CVtasa__0EF836A4]  DEFAULT (0) FOR [CVtasa]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__CVoper__0FEC5ADD]  DEFAULT (0) FOR [CVoper]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__CPCmon__10E07F16]  DEFAULT (0) FOR [CPCmonto]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__CPCope__11D4A34F]  DEFAULT (0) FOR [CPCoper]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__CPVmon__12C8C788]  DEFAULT (0) FOR [CPVmonto]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__CPVope__13BCEBC1]  DEFAULT (0) FOR [CPVoper]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__CICmon__14B10FFA]  DEFAULT (0) FOR [CICmonto]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__CICope__15A53433]  DEFAULT (0) FOR [CICoper]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__CIVmon__1699586C]  DEFAULT (0) FOR [CIVmonto]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__CIVope__178D7CA5]  DEFAULT (0) FOR [CIVoper]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__CCHmon__1881A0DE]  DEFAULT (0) FOR [CCHmonto]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__CHCmon__1975C517]  DEFAULT (0) FOR [CHCmonto]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__EBs__1A69E950]  DEFAULT (0) FOR [EBs]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__EUSD__1B5E0D89]  DEFAULT (0) FOR [EUSD]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__ECity__1C5231C2]  DEFAULT (0) FOR [ECity]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__EThom__1D4655FB]  DEFAULT (0) FOR [EThom]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__EVisa__1E3A7A34]  DEFAULT (0) FOR [EVisa]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__EAmex__1F2E9E6D]  DEFAULT (0) FOR [EAmex]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Umonto__2022C2A6]  DEFAULT (0) FOR [Umonto_62_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Utasa___2116E6DF]  DEFAULT (0) FOR [Utasa_62_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Uoper___220B0B18]  DEFAULT (0) FOR [Uoper_62_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Umonto__22FF2F51]  DEFAULT (0) FOR [Umonto_62_2_C]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Utasa___23F3538A]  DEFAULT (0) FOR [Utasa_62_2_C]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Uoper___24E777C3]  DEFAULT (0) FOR [Uoper_62_2_C]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__chcmon__55DFB4D9]  DEFAULT (0) FOR [chcmontod]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__eeur__56D3D912]  DEFAULT (0) FOR [eeur]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__EThome__5AA469F6]  DEFAULT (0) FOR [EThomeur]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__EAmexe__5B988E2F]  DEFAULT (0) FOR [EAmexeur]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__ethomd__78BEDCC2]  DEFAULT (0) FOR [ethomd]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__evisad__79B300FB]  DEFAULT (0) FOR [evisad]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__valesb__7AA72534]  DEFAULT (0) FOR [valesbs]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__valesu__7B9B496D]  DEFAULT (0) FOR [valesusd]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__valesd__7C8F6DA6]  DEFAULT (0) FOR [valesdiv]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Umonto__5887175A]  DEFAULT (0) FOR [Umonto_43_12]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Utasa___597B3B93]  DEFAULT (0) FOR [Utasa_43_12]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Uoper___5A6F5FCC]  DEFAULT (0) FOR [Uoper_43_12]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Umonto__5B638405]  DEFAULT (0) FOR [Umonto_44_12]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Utasa___5C57A83E]  DEFAULT (0) FOR [Utasa_44_12]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Uoper___5D4BCC77]  DEFAULT (0) FOR [Uoper_44_12]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Dmonto__5E3FF0B0]  DEFAULT (0) FOR [Dmonto_43_12]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Dtasa___5F3414E9]  DEFAULT (0) FOR [Dtasa_43_12]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Doper___60283922]  DEFAULT (0) FOR [Doper_43_12]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Dmonto__611C5D5B]  DEFAULT (0) FOR [Dmonto_44_12]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Dtasa___62108194]  DEFAULT (0) FOR [Dtasa_44_12]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  CONSTRAINT [DF__counters__Doper___6304A5CD]  DEFAULT (0) FOR [Doper_44_12]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  DEFAULT (0) FOR [edivisa]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  DEFAULT (0) FOR [eamexd]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  DEFAULT (0) FOR [emonto_43_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  DEFAULT (0) FOR [etasa_43_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  DEFAULT (0) FOR [eoper_43_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  DEFAULT (0) FOR [emonto_44_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  DEFAULT (0) FOR [etasa_44_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  DEFAULT (0) FOR [eoper_44_2]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  DEFAULT (0) FOR [chctasa]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  DEFAULT (0) FOR [chcoper]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  DEFAULT (0) FOR [chctasad]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  DEFAULT (0) FOR [chcoperd]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  DEFAULT (0) FOR [chcmontoe]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  DEFAULT (0) FOR [chctasae]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  DEFAULT (0) FOR [chcopere]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  DEFAULT (0) FOR [Dmonto_562_12]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  DEFAULT (0) FOR [Dtasa_562_12]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  DEFAULT (0) FOR [Doper_562_12]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  DEFAULT (0) FOR [umonto_562_12]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  DEFAULT (0) FOR [utasa_562_12]
GO

ALTER TABLE [dbo].[tCountersSii] ADD  DEFAULT (0) FOR [uoper_562_12]
GO


