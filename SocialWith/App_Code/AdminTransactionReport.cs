﻿using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

/// <summary>
/// Summary description for AdminTransactionReport
/// </summary>
public class AdminTransactionReport : DevExpress.XtraReports.UI.XtraReport
{
    private DetailBand Detail;
    private XRTable detailTable;
    private XRTableRow detailTableRow1;
    private TopMarginBand TopMargin;
    private BottomMarginBand BottomMargin;
    private GroupHeaderBand GroupHeader2;
    private GroupFooterBand GroupFooter1;
    private GroupHeaderBand GroupHeader1;
    private XRTable headerTable;
    private XRTableRow headerTableRow;
    private XRTableCell productDesctiptionCaption;
    private XRTableCell quantityCaption;
    private XRTableCell unitPriceCaption;
    private XRTableCell lineTotalCaption;
    private DevExpress.DataAccess.Sql.SqlDataSource sqlDataSource1;
    private XRControlStyle baseControlStyle;
    private XRTableCell xrTableCell5;
    private XRTableCell xrTableCell6;
    private XRTableCell xrTableCell7;
    private XRTableCell xrTableCell9;
    private XRTable invoiceInfoTable;
    private XRTableRow invoiceInfoTableRow2;
    private XRTableCell totalCaption2;
    private XRTableCell invoiceDateCaption;
    private XRTableCell xrTableCell34;
    private XRTableRow invoiceInfoTableRow3;
    private XRTableCell total2;
    private XRTableCell invoiceDate;
    private XRTableCell xrTableCell35;
    private XRTableRow xrTableRow1;
    private XRTableCell xrTableCell10;
    private XRTableCell xrTableCell11;
    private XRTableCell xrTableCell36;
    private XRTableRow xrTableRow2;
    private XRTableCell xrTableCell13;
    private XRTableCell xrTableCell14;
    private XRTableCell xrTableCell37;
    private XRTableRow xrTableRow3;
    private XRTableCell xrTableCell16;
    private XRTableCell xrTableCell17;
    private XRTableCell xrTableCell38;
    private XRTableCell xrTableCell1;
    private XRTableCell xrTableCell3;
    private XRTableCell productName;
    private XRTableCell xrTableCell4;
    private XRTable xrTable1;
    private XRTableRow xrTableRow14;
    private XRTableCell xrTableCell60;
    private XRTableCell xrTableCell61;
    private XRTableRow xrTableRow15;
    private XRTableCell xrTableCell63;
    private XRTableCell xrTableCell64;
    private XRTableRow xrTableRow16;
    private XRTableCell xrTableCell66;
    private XRTableCell xrTableCell67;
    private XRTable xrTable2;
    private XRTableRow xrTableRow9;
    private XRTableCell xrTableCell39;
    private XRTableRow xrTableRow10;
    private XRTableCell xrTableCell41;
    private XRTableCell xrTableCell40;
    private XRTableCell xrTableCell43;
    private XRTableCell xrTableCell42;
    private XRLabel lblDateTime;
    private ReportHeaderBand ReportHeader;
    private XRLabel xrLabel1;
    private XRTable xrTable3;
    private XRTableRow xrTableRow19;
    private XRTableCell xrTableCell70;
    private XRTableCell xrTableCell71;
    private XRTableCell xrTableCell72;
    private XRTableRow xrTableRow20;
    private XRTableCell xrTableCell73;
    private XRTableCell xrTableCell74;
    private XRTableCell xrTableCell75;
    private XRTableRow xrTableRow21;
    private XRTableCell xrTableCell76;
    private XRTableCell xrTableCell77;
    private XRTableCell xrTableCell78;
    private XRTableRow xrTableRow22;
    private XRTableCell xrTableCell79;
    private XRTableCell xrTableCell80;
    private XRTableCell xrTableCell81;
    private XRTableRow xrTableRow23;
    private XRTableCell xrTableCell82;
    private XRTableCell xrTableCell83;
    private XRTableCell xrTableCell84;
    private XRPictureBox oBox;
    private XRPanel xrPanel1;
    private XRLabel xrLabel8;
    private XRLabel xrLabel7;
    private XRLabel xrLabel6;
    private XRLabel xrLabel5;
    private XRLabel xrLabel4;
    private XRLabel xrLabel3;
    private XRLabel xrLabel2;
    private XRTableRow xrTableRow4;
    private XRTableCell xrTableCell2;
    private XRTableCell xrTableCell8;
    private XRTable xrTable4;
    private XRTableRow xrTableRow5;
    private XRTableCell xrTableCell12;

    /// <summary>
    /// Required designer variable.
    /// </summary>
    private System.ComponentModel.IContainer components = null;

    public AdminTransactionReport()
    {
        InitializeComponent();
        //
        // TODO: Add constructor logic here
        //
    }

    /// <summary> 
    /// Clean up any resources being used.
    /// </summary>
    /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
    protected override void Dispose(bool disposing)
    {
        if (disposing && (components != null))
        {
            components.Dispose();
        }
        base.Dispose(disposing);
    }

    #region Designer generated code

    /// <summary>
    /// Required method for Designer support - do not modify
    /// the contents of this method with the code editor.
    /// </summary>
    private void InitializeComponent()
    {
            string resourceFileName = "AdminTransactionReport.resx";
            this.components = new System.ComponentModel.Container();
            DevExpress.DataAccess.Sql.StoredProcQuery storedProcQuery1 = new DevExpress.DataAccess.Sql.StoredProcQuery();
            DevExpress.DataAccess.Sql.QueryParameter queryParameter1 = new DevExpress.DataAccess.Sql.QueryParameter();
            DevExpress.DataAccess.Sql.QueryParameter queryParameter2 = new DevExpress.DataAccess.Sql.QueryParameter();
            DevExpress.DataAccess.Sql.QueryParameter queryParameter3 = new DevExpress.DataAccess.Sql.QueryParameter();
            DevExpress.DataAccess.Sql.QueryParameter queryParameter4 = new DevExpress.DataAccess.Sql.QueryParameter();
            DevExpress.DataAccess.Sql.QueryParameter queryParameter5 = new DevExpress.DataAccess.Sql.QueryParameter();
            this.Detail = new DevExpress.XtraReports.UI.DetailBand();
            this.detailTable = new DevExpress.XtraReports.UI.XRTable();
            this.detailTableRow1 = new DevExpress.XtraReports.UI.XRTableRow();
            this.productName = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell4 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell5 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell6 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell7 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell9 = new DevExpress.XtraReports.UI.XRTableCell();
            this.TopMargin = new DevExpress.XtraReports.UI.TopMarginBand();
            this.BottomMargin = new DevExpress.XtraReports.UI.BottomMarginBand();
            this.GroupHeader2 = new DevExpress.XtraReports.UI.GroupHeaderBand();
            this.oBox = new DevExpress.XtraReports.UI.XRPictureBox();
            this.xrTable3 = new DevExpress.XtraReports.UI.XRTable();
            this.xrTableRow19 = new DevExpress.XtraReports.UI.XRTableRow();
            this.xrTableCell70 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell71 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell72 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableRow20 = new DevExpress.XtraReports.UI.XRTableRow();
            this.xrTableCell73 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell74 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell75 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableRow21 = new DevExpress.XtraReports.UI.XRTableRow();
            this.xrTableCell76 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell77 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell78 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableRow22 = new DevExpress.XtraReports.UI.XRTableRow();
            this.xrTableCell79 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell80 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell81 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableRow23 = new DevExpress.XtraReports.UI.XRTableRow();
            this.xrTableCell82 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell83 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell84 = new DevExpress.XtraReports.UI.XRTableCell();
            this.lblDateTime = new DevExpress.XtraReports.UI.XRLabel();
            this.xrTable2 = new DevExpress.XtraReports.UI.XRTable();
            this.xrTableRow9 = new DevExpress.XtraReports.UI.XRTableRow();
            this.xrTableCell39 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableRow10 = new DevExpress.XtraReports.UI.XRTableRow();
            this.xrTableCell41 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell40 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell43 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell42 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableRow4 = new DevExpress.XtraReports.UI.XRTableRow();
            this.xrTableCell2 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell8 = new DevExpress.XtraReports.UI.XRTableCell();
            this.invoiceInfoTable = new DevExpress.XtraReports.UI.XRTable();
            this.invoiceInfoTableRow2 = new DevExpress.XtraReports.UI.XRTableRow();
            this.totalCaption2 = new DevExpress.XtraReports.UI.XRTableCell();
            this.invoiceDateCaption = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell34 = new DevExpress.XtraReports.UI.XRTableCell();
            this.invoiceInfoTableRow3 = new DevExpress.XtraReports.UI.XRTableRow();
            this.total2 = new DevExpress.XtraReports.UI.XRTableCell();
            this.invoiceDate = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell35 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableRow1 = new DevExpress.XtraReports.UI.XRTableRow();
            this.xrTableCell10 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell11 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell36 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableRow2 = new DevExpress.XtraReports.UI.XRTableRow();
            this.xrTableCell13 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell14 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell37 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableRow3 = new DevExpress.XtraReports.UI.XRTableRow();
            this.xrTableCell16 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell17 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell38 = new DevExpress.XtraReports.UI.XRTableCell();
            this.GroupFooter1 = new DevExpress.XtraReports.UI.GroupFooterBand();
            this.xrTable4 = new DevExpress.XtraReports.UI.XRTable();
            this.xrTableRow5 = new DevExpress.XtraReports.UI.XRTableRow();
            this.xrTableCell12 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrPanel1 = new DevExpress.XtraReports.UI.XRPanel();
            this.xrLabel8 = new DevExpress.XtraReports.UI.XRLabel();
            this.xrLabel7 = new DevExpress.XtraReports.UI.XRLabel();
            this.xrLabel6 = new DevExpress.XtraReports.UI.XRLabel();
            this.xrLabel5 = new DevExpress.XtraReports.UI.XRLabel();
            this.xrLabel4 = new DevExpress.XtraReports.UI.XRLabel();
            this.xrLabel3 = new DevExpress.XtraReports.UI.XRLabel();
            this.xrLabel2 = new DevExpress.XtraReports.UI.XRLabel();
            this.xrTable1 = new DevExpress.XtraReports.UI.XRTable();
            this.xrTableRow14 = new DevExpress.XtraReports.UI.XRTableRow();
            this.xrTableCell60 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell61 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableRow15 = new DevExpress.XtraReports.UI.XRTableRow();
            this.xrTableCell63 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell64 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableRow16 = new DevExpress.XtraReports.UI.XRTableRow();
            this.xrTableCell66 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell67 = new DevExpress.XtraReports.UI.XRTableCell();
            this.GroupHeader1 = new DevExpress.XtraReports.UI.GroupHeaderBand();
            this.headerTable = new DevExpress.XtraReports.UI.XRTable();
            this.headerTableRow = new DevExpress.XtraReports.UI.XRTableRow();
            this.productDesctiptionCaption = new DevExpress.XtraReports.UI.XRTableCell();
            this.quantityCaption = new DevExpress.XtraReports.UI.XRTableCell();
            this.unitPriceCaption = new DevExpress.XtraReports.UI.XRTableCell();
            this.lineTotalCaption = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell1 = new DevExpress.XtraReports.UI.XRTableCell();
            this.xrTableCell3 = new DevExpress.XtraReports.UI.XRTableCell();
            this.sqlDataSource1 = new DevExpress.DataAccess.Sql.SqlDataSource(this.components);
            this.baseControlStyle = new DevExpress.XtraReports.UI.XRControlStyle();
            this.ReportHeader = new DevExpress.XtraReports.UI.ReportHeaderBand();
            this.xrLabel1 = new DevExpress.XtraReports.UI.XRLabel();
            ((System.ComponentModel.ISupportInitialize)(this.detailTable)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.xrTable3)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.xrTable2)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.invoiceInfoTable)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.xrTable4)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.xrTable1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.headerTable)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this)).BeginInit();
            // 
            // Detail
            // 
            this.Detail.Controls.AddRange(new DevExpress.XtraReports.UI.XRControl[] {
            this.detailTable});
            this.Detail.HeightF = 35.41987F;
            this.Detail.Name = "Detail";
            this.Detail.Padding = new DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 100F);
            this.Detail.StyleName = "baseControlStyle";
            this.Detail.StylePriority.UseBorders = false;
            this.Detail.StylePriority.UseBorderWidth = false;
            this.Detail.StylePriority.UsePadding = false;
            this.Detail.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft;
            // 
            // detailTable
            // 
            this.detailTable.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(229)))), ((int)(((byte)(224)))), ((int)(((byte)(220)))));
            this.detailTable.BorderColor = System.Drawing.Color.Black;
            this.detailTable.Font = new System.Drawing.Font("Segoe UI", 9.75F, System.Drawing.FontStyle.Bold);
            this.detailTable.LocationFloat = new DevExpress.Utils.PointFloat(6.00001F, 0F);
            this.detailTable.Name = "detailTable";
            this.detailTable.Padding = new DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 100F);
            this.detailTable.Rows.AddRange(new DevExpress.XtraReports.UI.XRTableRow[] {
            this.detailTableRow1});
            this.detailTable.SizeF = new System.Drawing.SizeF(730.9999F, 35.41987F);
            this.detailTable.StylePriority.UseBackColor = false;
            this.detailTable.StylePriority.UseBorderColor = false;
            this.detailTable.StylePriority.UseBorders = false;
            this.detailTable.StylePriority.UseFont = false;
            this.detailTable.StylePriority.UsePadding = false;
            // 
            // detailTableRow1
            // 
            this.detailTableRow1.Cells.AddRange(new DevExpress.XtraReports.UI.XRTableCell[] {
            this.productName,
            this.xrTableCell4,
            this.xrTableCell5,
            this.xrTableCell6,
            this.xrTableCell7,
            this.xrTableCell9});
            this.detailTableRow1.Name = "detailTableRow1";
            this.detailTableRow1.Weight = 10.58D;
            // 
            // productName
            // 
            this.productName.BackColor = System.Drawing.Color.White;
            this.productName.BorderColor = System.Drawing.Color.Black;
            this.productName.Borders = ((DevExpress.XtraPrinting.BorderSide)(((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.productName.BorderWidth = 1F;
            this.productName.ExpressionBindings.AddRange(new DevExpress.XtraReports.UI.ExpressionBinding[] {
            new DevExpress.XtraReports.UI.ExpressionBinding("BeforePrint", "Text", "[DataSource.CurrentRowIndex] +1")});
            this.productName.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.productName.Name = "productName";
            this.productName.Padding = new DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 100F);
            this.productName.StylePriority.UseBackColor = false;
            this.productName.StylePriority.UseBorderColor = false;
            this.productName.StylePriority.UseBorders = false;
            this.productName.StylePriority.UseBorderWidth = false;
            this.productName.StylePriority.UseFont = false;
            this.productName.StylePriority.UsePadding = false;
            this.productName.StylePriority.UseTextAlignment = false;
            this.productName.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            this.productName.Weight = 0.051599997845200127D;
            // 
            // xrTableCell4
            // 
            this.xrTableCell4.BackColor = System.Drawing.Color.White;
            this.xrTableCell4.BorderColor = System.Drawing.Color.Black;
            this.xrTableCell4.Borders = ((DevExpress.XtraPrinting.BorderSide)(((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTableCell4.BorderWidth = 1F;
            this.xrTableCell4.ExpressionBindings.AddRange(new DevExpress.XtraReports.UI.ExpressionBinding[] {
            new DevExpress.XtraReports.UI.ExpressionBinding("BeforePrint", "Text", "[GOODSCODE]"),
            new DevExpress.XtraReports.UI.ExpressionBinding("BeforePrint", "Text", "[GOODSCODE]")});
            this.xrTableCell4.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.xrTableCell4.Name = "xrTableCell4";
            this.xrTableCell4.Padding = new DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 100F);
            this.xrTableCell4.StylePriority.UseBackColor = false;
            this.xrTableCell4.StylePriority.UseBorderColor = false;
            this.xrTableCell4.StylePriority.UseBorders = false;
            this.xrTableCell4.StylePriority.UseBorderWidth = false;
            this.xrTableCell4.StylePriority.UseFont = false;
            this.xrTableCell4.StylePriority.UsePadding = false;
            this.xrTableCell4.StylePriority.UseTextAlignment = false;
            this.xrTableCell4.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            this.xrTableCell4.Weight = 0.14410129207348463D;
            // 
            // xrTableCell5
            // 
            this.xrTableCell5.BackColor = System.Drawing.Color.White;
            this.xrTableCell5.BorderColor = System.Drawing.Color.Black;
            this.xrTableCell5.Borders = ((DevExpress.XtraPrinting.BorderSide)(((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTableCell5.BorderWidth = 1F;
            this.xrTableCell5.CanGrow = false;
            this.xrTableCell5.ExpressionBindings.AddRange(new DevExpress.XtraReports.UI.ExpressionBinding[] {
            new DevExpress.XtraReports.UI.ExpressionBinding("BeforePrint", "Text", "\'[\'+ [BRANDNAME]+ \']\' + [GOODSFINALNAME] +\'\n\'+[GOODSOPTIONSUMMARYVALUES]")});
            this.xrTableCell5.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.xrTableCell5.Multiline = true;
            this.xrTableCell5.Name = "xrTableCell5";
            this.xrTableCell5.Padding = new DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 2, 100F);
            this.xrTableCell5.StylePriority.UseBackColor = false;
            this.xrTableCell5.StylePriority.UseBorderColor = false;
            this.xrTableCell5.StylePriority.UseBorders = false;
            this.xrTableCell5.StylePriority.UseBorderWidth = false;
            this.xrTableCell5.StylePriority.UseFont = false;
            this.xrTableCell5.StylePriority.UsePadding = false;
            this.xrTableCell5.StylePriority.UseTextAlignment = false;
            this.xrTableCell5.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft;
            this.xrTableCell5.Weight = 0.4055579978208973D;
            this.xrTableCell5.WordWrap = false;
            // 
            // xrTableCell6
            // 
            this.xrTableCell6.BackColor = System.Drawing.Color.White;
            this.xrTableCell6.BorderColor = System.Drawing.Color.Black;
            this.xrTableCell6.Borders = ((DevExpress.XtraPrinting.BorderSide)(((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTableCell6.BorderWidth = 1F;
            this.xrTableCell6.ExpressionBindings.AddRange(new DevExpress.XtraReports.UI.ExpressionBinding[] {
            new DevExpress.XtraReports.UI.ExpressionBinding("BeforePrint", "Text", "[GOODSSALEPRICEVAT]")});
            this.xrTableCell6.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.xrTableCell6.Name = "xrTableCell6";
            this.xrTableCell6.Padding = new DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 100F);
            this.xrTableCell6.StylePriority.UseBackColor = false;
            this.xrTableCell6.StylePriority.UseBorderColor = false;
            this.xrTableCell6.StylePriority.UseBorders = false;
            this.xrTableCell6.StylePriority.UseBorderWidth = false;
            this.xrTableCell6.StylePriority.UseFont = false;
            this.xrTableCell6.StylePriority.UsePadding = false;
            this.xrTableCell6.StylePriority.UseTextAlignment = false;
            this.xrTableCell6.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleRight;
            this.xrTableCell6.TextFormatString = "{0:#,###원}";
            this.xrTableCell6.Weight = 0.11995438005859294D;
            // 
            // xrTableCell7
            // 
            this.xrTableCell7.BackColor = System.Drawing.Color.White;
            this.xrTableCell7.BorderColor = System.Drawing.Color.Black;
            this.xrTableCell7.Borders = ((DevExpress.XtraPrinting.BorderSide)(((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTableCell7.BorderWidth = 1F;
            this.xrTableCell7.ExpressionBindings.AddRange(new DevExpress.XtraReports.UI.ExpressionBinding[] {
            new DevExpress.XtraReports.UI.ExpressionBinding("BeforePrint", "Text", "[QTY] + \'\' +[GOODSUNIT_NAME]")});
            this.xrTableCell7.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.xrTableCell7.Name = "xrTableCell7";
            this.xrTableCell7.Padding = new DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 100F);
            this.xrTableCell7.StylePriority.UseBackColor = false;
            this.xrTableCell7.StylePriority.UseBorderColor = false;
            this.xrTableCell7.StylePriority.UseBorders = false;
            this.xrTableCell7.StylePriority.UseBorderWidth = false;
            this.xrTableCell7.StylePriority.UseFont = false;
            this.xrTableCell7.StylePriority.UsePadding = false;
            this.xrTableCell7.StylePriority.UseTextAlignment = false;
            this.xrTableCell7.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            this.xrTableCell7.Weight = 0.15379970942694D;
            // 
            // xrTableCell9
            // 
            this.xrTableCell9.BackColor = System.Drawing.Color.White;
            this.xrTableCell9.BorderColor = System.Drawing.Color.Black;
            this.xrTableCell9.Borders = ((DevExpress.XtraPrinting.BorderSide)(((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTableCell9.BorderWidth = 1F;
            this.xrTableCell9.ExpressionBindings.AddRange(new DevExpress.XtraReports.UI.ExpressionBinding[] {
            new DevExpress.XtraReports.UI.ExpressionBinding("BeforePrint", "Text", "[GOODSTOTALSALEPRICEVAT]")});
            this.xrTableCell9.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.xrTableCell9.Name = "xrTableCell9";
            this.xrTableCell9.Padding = new DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 100F);
            this.xrTableCell9.StylePriority.UseBackColor = false;
            this.xrTableCell9.StylePriority.UseBorderColor = false;
            this.xrTableCell9.StylePriority.UseBorders = false;
            this.xrTableCell9.StylePriority.UseBorderWidth = false;
            this.xrTableCell9.StylePriority.UseFont = false;
            this.xrTableCell9.StylePriority.UsePadding = false;
            this.xrTableCell9.StylePriority.UseTextAlignment = false;
            this.xrTableCell9.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleRight;
            this.xrTableCell9.TextFormatString = "{0:n0}원";
            this.xrTableCell9.Weight = 0.15254446307894529D;
            // 
            // TopMargin
            // 
            this.TopMargin.HeightF = 0F;
            this.TopMargin.Name = "TopMargin";
            this.TopMargin.Padding = new DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 100F);
            this.TopMargin.StylePriority.UseBackColor = false;
            this.TopMargin.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft;
            // 
            // BottomMargin
            // 
            this.BottomMargin.HeightF = 22F;
            this.BottomMargin.Name = "BottomMargin";
            this.BottomMargin.Padding = new DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 100F);
            this.BottomMargin.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft;
            // 
            // GroupHeader2
            // 
            this.GroupHeader2.Controls.AddRange(new DevExpress.XtraReports.UI.XRControl[] {
            this.oBox,
            this.xrTable3,
            this.lblDateTime,
            this.xrTable2,
            this.invoiceInfoTable});
            this.GroupHeader2.GroupFields.AddRange(new DevExpress.XtraReports.UI.GroupField[] {
            new DevExpress.XtraReports.UI.GroupField("InvoiceNumber", DevExpress.XtraReports.UI.XRColumnSortOrder.Ascending)});
            this.GroupHeader2.GroupUnion = DevExpress.XtraReports.UI.GroupUnion.WithFirstDetail;
            this.GroupHeader2.HeightF = 452.0972F;
            this.GroupHeader2.KeepTogether = true;
            this.GroupHeader2.Level = 1;
            this.GroupHeader2.Name = "GroupHeader2";
            this.GroupHeader2.StyleName = "baseControlStyle";
            this.GroupHeader2.StylePriority.UseBackColor = false;
            // 
            // oBox
            // 
            this.oBox.AnchorVertical = ((DevExpress.XtraReports.UI.VerticalAnchorStyles)((DevExpress.XtraReports.UI.VerticalAnchorStyles.Top | DevExpress.XtraReports.UI.VerticalAnchorStyles.Bottom)));
            this.oBox.Borders = ((DevExpress.XtraPrinting.BorderSide)((((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Top) 
            | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.oBox.BorderWidth = 1F;
            this.oBox.ExpressionBindings.AddRange(new DevExpress.XtraReports.UI.ExpressionBinding[] {
            new DevExpress.XtraReports.UI.ExpressionBinding("BeforePrint", "ImageUrl", "\' http://www.socialwith.co.kr/UploadFile\' +[ATTACH_PATH] +[ATTACH_P_NAME]")});
            this.oBox.ImageAlignment = DevExpress.XtraPrinting.ImageAlignment.MiddleCenter;
            this.oBox.LocationFloat = new DevExpress.Utils.PointFloat(581.8928F, 31.00001F);
            this.oBox.Name = "oBox";
            this.oBox.SizeF = new System.Drawing.SizeF(155.1072F, 157.2962F);
            this.oBox.StylePriority.UseBorders = false;
            this.oBox.StylePriority.UseBorderWidth = false;
            // 
            // xrTable3
            // 
            this.xrTable3.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(229)))), ((int)(((byte)(224)))), ((int)(((byte)(220)))));
            this.xrTable3.Borders = ((DevExpress.XtraPrinting.BorderSide)((((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Top) 
            | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTable3.LocationFloat = new DevExpress.Utils.PointFloat(6.00001F, 188.2962F);
            this.xrTable3.Name = "xrTable3";
            this.xrTable3.Rows.AddRange(new DevExpress.XtraReports.UI.XRTableRow[] {
            this.xrTableRow19,
            this.xrTableRow20,
            this.xrTableRow21,
            this.xrTableRow22,
            this.xrTableRow23});
            this.xrTable3.SizeF = new System.Drawing.SizeF(730.9999F, 156.2547F);
            this.xrTable3.StylePriority.UseBackColor = false;
            this.xrTable3.StylePriority.UseBorders = false;
            // 
            // xrTableRow19
            // 
            this.xrTableRow19.Borders = ((DevExpress.XtraPrinting.BorderSide)((((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Top) 
            | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTableRow19.BorderWidth = 0.5F;
            this.xrTableRow19.Cells.AddRange(new DevExpress.XtraReports.UI.XRTableCell[] {
            this.xrTableCell70,
            this.xrTableCell71,
            this.xrTableCell72});
            this.xrTableRow19.Name = "xrTableRow19";
            this.xrTableRow19.StylePriority.UseBorders = false;
            this.xrTableRow19.StylePriority.UseBorderWidth = false;
            this.xrTableRow19.Weight = 0.41666778564453133D;
            // 
            // xrTableCell70
            // 
            this.xrTableCell70.BorderColor = System.Drawing.Color.Black;
            this.xrTableCell70.Borders = ((DevExpress.XtraPrinting.BorderSide)(((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTableCell70.BorderWidth = 1F;
            this.xrTableCell70.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrTableCell70.Multiline = true;
            this.xrTableCell70.Name = "xrTableCell70";
            this.xrTableCell70.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrTableCell70.RowSpan = 5;
            this.xrTableCell70.StylePriority.UseBorderColor = false;
            this.xrTableCell70.StylePriority.UseBorders = false;
            this.xrTableCell70.StylePriority.UseBorderWidth = false;
            this.xrTableCell70.StylePriority.UseFont = false;
            this.xrTableCell70.StylePriority.UsePadding = false;
            this.xrTableCell70.StylePriority.UseTextAlignment = false;
            this.xrTableCell70.Text = "공\r\n급\r\n받\r\n는\r\n자";
            this.xrTableCell70.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            this.xrTableCell70.Weight = 0.10843551868807543D;
            // 
            // xrTableCell71
            // 
            this.xrTableCell71.Borders = ((DevExpress.XtraPrinting.BorderSide)((DevExpress.XtraPrinting.BorderSide.Right | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTableCell71.BorderWidth = 1F;
            this.xrTableCell71.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrTableCell71.Name = "xrTableCell71";
            this.xrTableCell71.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrTableCell71.StylePriority.UseBorders = false;
            this.xrTableCell71.StylePriority.UseBorderWidth = false;
            this.xrTableCell71.StylePriority.UseFont = false;
            this.xrTableCell71.StylePriority.UsePadding = false;
            this.xrTableCell71.StylePriority.UseTextAlignment = false;
            this.xrTableCell71.Text = "사업자등록번호";
            this.xrTableCell71.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            this.xrTableCell71.Weight = 0.45680655963019279D;
            // 
            // xrTableCell72
            // 
            this.xrTableCell72.BackColor = System.Drawing.Color.White;
            this.xrTableCell72.BorderColor = System.Drawing.Color.Black;
            this.xrTableCell72.Borders = ((DevExpress.XtraPrinting.BorderSide)((DevExpress.XtraPrinting.BorderSide.Right | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTableCell72.BorderWidth = 1F;
            this.xrTableCell72.ExpressionBindings.AddRange(new DevExpress.XtraReports.UI.ExpressionBinding[] {
            new DevExpress.XtraReports.UI.ExpressionBinding("BeforePrint", "Text", "[COMPANY_NO]")});
            this.xrTableCell72.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrTableCell72.ForeColor = System.Drawing.Color.Black;
            this.xrTableCell72.Name = "xrTableCell72";
            this.xrTableCell72.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 0, 0, 0, 100F);
            this.xrTableCell72.StylePriority.UseBackColor = false;
            this.xrTableCell72.StylePriority.UseBorderColor = false;
            this.xrTableCell72.StylePriority.UseBorders = false;
            this.xrTableCell72.StylePriority.UseBorderWidth = false;
            this.xrTableCell72.StylePriority.UseFont = false;
            this.xrTableCell72.StylePriority.UseForeColor = false;
            this.xrTableCell72.StylePriority.UsePadding = false;
            this.xrTableCell72.StylePriority.UseTextAlignment = false;
            this.xrTableCell72.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft;
            this.xrTableCell72.Weight = 2.4026427586535095D;
            // 
            // xrTableRow20
            // 
            this.xrTableRow20.Cells.AddRange(new DevExpress.XtraReports.UI.XRTableCell[] {
            this.xrTableCell73,
            this.xrTableCell74,
            this.xrTableCell75});
            this.xrTableRow20.Name = "xrTableRow20";
            this.xrTableRow20.Weight = 0.41666778564453133D;
            // 
            // xrTableCell73
            // 
            this.xrTableCell73.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(211)))), ((int)(((byte)(203)))), ((int)(((byte)(200)))));
            this.xrTableCell73.Borders = DevExpress.XtraPrinting.BorderSide.Right;
            this.xrTableCell73.Name = "xrTableCell73";
            this.xrTableCell73.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrTableCell73.StylePriority.UseBorderColor = false;
            this.xrTableCell73.StylePriority.UseBorders = false;
            this.xrTableCell73.StylePriority.UsePadding = false;
            this.xrTableCell73.StylePriority.UseTextAlignment = false;
            this.xrTableCell73.Text = "xrTableCell22";
            this.xrTableCell73.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter;
            this.xrTableCell73.Weight = 0.10843551868807543D;
            // 
            // xrTableCell74
            // 
            this.xrTableCell74.Borders = ((DevExpress.XtraPrinting.BorderSide)(((DevExpress.XtraPrinting.BorderSide.Top | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTableCell74.BorderWidth = 1F;
            this.xrTableCell74.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrTableCell74.Name = "xrTableCell74";
            this.xrTableCell74.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrTableCell74.StylePriority.UseBorders = false;
            this.xrTableCell74.StylePriority.UseBorderWidth = false;
            this.xrTableCell74.StylePriority.UseFont = false;
            this.xrTableCell74.StylePriority.UsePadding = false;
            this.xrTableCell74.StylePriority.UseTextAlignment = false;
            this.xrTableCell74.Text = "상호(법인명)";
            this.xrTableCell74.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            this.xrTableCell74.Weight = 0.45680655963019279D;
            // 
            // xrTableCell75
            // 
            this.xrTableCell75.BackColor = System.Drawing.Color.White;
            this.xrTableCell75.BorderColor = System.Drawing.Color.Black;
            this.xrTableCell75.Borders = ((DevExpress.XtraPrinting.BorderSide)((DevExpress.XtraPrinting.BorderSide.Right | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTableCell75.BorderWidth = 1F;
            this.xrTableCell75.ExpressionBindings.AddRange(new DevExpress.XtraReports.UI.ExpressionBinding[] {
            new DevExpress.XtraReports.UI.ExpressionBinding("BeforePrint", "Text", "[COMPANY_NAME]")});
            this.xrTableCell75.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrTableCell75.ForeColor = System.Drawing.Color.Black;
            this.xrTableCell75.Name = "xrTableCell75";
            this.xrTableCell75.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 0, 0, 0, 100F);
            this.xrTableCell75.StylePriority.UseBackColor = false;
            this.xrTableCell75.StylePriority.UseBorderColor = false;
            this.xrTableCell75.StylePriority.UseBorders = false;
            this.xrTableCell75.StylePriority.UseBorderWidth = false;
            this.xrTableCell75.StylePriority.UseFont = false;
            this.xrTableCell75.StylePriority.UseForeColor = false;
            this.xrTableCell75.StylePriority.UsePadding = false;
            this.xrTableCell75.StylePriority.UseTextAlignment = false;
            this.xrTableCell75.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft;
            this.xrTableCell75.Weight = 2.4026427586535095D;
            // 
            // xrTableRow21
            // 
            this.xrTableRow21.Cells.AddRange(new DevExpress.XtraReports.UI.XRTableCell[] {
            this.xrTableCell76,
            this.xrTableCell77,
            this.xrTableCell78});
            this.xrTableRow21.Name = "xrTableRow21";
            this.xrTableRow21.Weight = 0.41666778564453133D;
            // 
            // xrTableCell76
            // 
            this.xrTableCell76.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(211)))), ((int)(((byte)(203)))), ((int)(((byte)(200)))));
            this.xrTableCell76.Borders = DevExpress.XtraPrinting.BorderSide.Right;
            this.xrTableCell76.Name = "xrTableCell76";
            this.xrTableCell76.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrTableCell76.StylePriority.UseBorderColor = false;
            this.xrTableCell76.StylePriority.UseBorders = false;
            this.xrTableCell76.StylePriority.UsePadding = false;
            this.xrTableCell76.StylePriority.UseTextAlignment = false;
            this.xrTableCell76.Text = "xrTableCell25";
            this.xrTableCell76.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter;
            this.xrTableCell76.Weight = 0.10843551868807543D;
            // 
            // xrTableCell77
            // 
            this.xrTableCell77.Borders = ((DevExpress.XtraPrinting.BorderSide)(((DevExpress.XtraPrinting.BorderSide.Top | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTableCell77.BorderWidth = 1F;
            this.xrTableCell77.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrTableCell77.Name = "xrTableCell77";
            this.xrTableCell77.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrTableCell77.StylePriority.UseBorders = false;
            this.xrTableCell77.StylePriority.UseBorderWidth = false;
            this.xrTableCell77.StylePriority.UseFont = false;
            this.xrTableCell77.StylePriority.UsePadding = false;
            this.xrTableCell77.StylePriority.UseTextAlignment = false;
            this.xrTableCell77.Text = "성명(대표자명)";
            this.xrTableCell77.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            this.xrTableCell77.Weight = 0.45680655963019279D;
            // 
            // xrTableCell78
            // 
            this.xrTableCell78.BackColor = System.Drawing.Color.White;
            this.xrTableCell78.BorderColor = System.Drawing.Color.Black;
            this.xrTableCell78.Borders = ((DevExpress.XtraPrinting.BorderSide)((DevExpress.XtraPrinting.BorderSide.Right | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTableCell78.BorderWidth = 1F;
            this.xrTableCell78.ExpressionBindings.AddRange(new DevExpress.XtraReports.UI.ExpressionBinding[] {
            new DevExpress.XtraReports.UI.ExpressionBinding("BeforePrint", "Text", "[COMPANY_DELIGATENAME]")});
            this.xrTableCell78.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrTableCell78.ForeColor = System.Drawing.Color.Black;
            this.xrTableCell78.Name = "xrTableCell78";
            this.xrTableCell78.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 0, 0, 0, 100F);
            this.xrTableCell78.StylePriority.UseBackColor = false;
            this.xrTableCell78.StylePriority.UseBorderColor = false;
            this.xrTableCell78.StylePriority.UseBorders = false;
            this.xrTableCell78.StylePriority.UseBorderWidth = false;
            this.xrTableCell78.StylePriority.UseFont = false;
            this.xrTableCell78.StylePriority.UseForeColor = false;
            this.xrTableCell78.StylePriority.UsePadding = false;
            this.xrTableCell78.StylePriority.UseTextAlignment = false;
            this.xrTableCell78.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft;
            this.xrTableCell78.Weight = 2.4026427586535095D;
            // 
            // xrTableRow22
            // 
            this.xrTableRow22.Cells.AddRange(new DevExpress.XtraReports.UI.XRTableCell[] {
            this.xrTableCell79,
            this.xrTableCell80,
            this.xrTableCell81});
            this.xrTableRow22.Name = "xrTableRow22";
            this.xrTableRow22.Weight = 0.41666778564453133D;
            // 
            // xrTableCell79
            // 
            this.xrTableCell79.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(211)))), ((int)(((byte)(203)))), ((int)(((byte)(200)))));
            this.xrTableCell79.Borders = DevExpress.XtraPrinting.BorderSide.Right;
            this.xrTableCell79.Name = "xrTableCell79";
            this.xrTableCell79.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrTableCell79.StylePriority.UseBorderColor = false;
            this.xrTableCell79.StylePriority.UseBorders = false;
            this.xrTableCell79.StylePriority.UsePadding = false;
            this.xrTableCell79.StylePriority.UseTextAlignment = false;
            this.xrTableCell79.Text = "xrTableCell28";
            this.xrTableCell79.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter;
            this.xrTableCell79.Weight = 0.10843551868807543D;
            // 
            // xrTableCell80
            // 
            this.xrTableCell80.Borders = ((DevExpress.XtraPrinting.BorderSide)(((DevExpress.XtraPrinting.BorderSide.Top | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTableCell80.BorderWidth = 1F;
            this.xrTableCell80.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrTableCell80.Name = "xrTableCell80";
            this.xrTableCell80.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrTableCell80.StylePriority.UseBorders = false;
            this.xrTableCell80.StylePriority.UseBorderWidth = false;
            this.xrTableCell80.StylePriority.UseFont = false;
            this.xrTableCell80.StylePriority.UsePadding = false;
            this.xrTableCell80.StylePriority.UseTextAlignment = false;
            this.xrTableCell80.Text = "전화번호";
            this.xrTableCell80.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            this.xrTableCell80.Weight = 0.45680655963019279D;
            // 
            // xrTableCell81
            // 
            this.xrTableCell81.BackColor = System.Drawing.Color.White;
            this.xrTableCell81.BorderColor = System.Drawing.Color.Black;
            this.xrTableCell81.Borders = ((DevExpress.XtraPrinting.BorderSide)((DevExpress.XtraPrinting.BorderSide.Right | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTableCell81.BorderWidth = 1F;
            this.xrTableCell81.ExpressionBindings.AddRange(new DevExpress.XtraReports.UI.ExpressionBinding[] {
            new DevExpress.XtraReports.UI.ExpressionBinding("BeforePrint", "Text", "[COMPANY_TEL]")});
            this.xrTableCell81.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrTableCell81.ForeColor = System.Drawing.Color.Black;
            this.xrTableCell81.Name = "xrTableCell81";
            this.xrTableCell81.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 0, 0, 0, 100F);
            this.xrTableCell81.StylePriority.UseBackColor = false;
            this.xrTableCell81.StylePriority.UseBorderColor = false;
            this.xrTableCell81.StylePriority.UseBorders = false;
            this.xrTableCell81.StylePriority.UseBorderWidth = false;
            this.xrTableCell81.StylePriority.UseFont = false;
            this.xrTableCell81.StylePriority.UseForeColor = false;
            this.xrTableCell81.StylePriority.UsePadding = false;
            this.xrTableCell81.StylePriority.UseTextAlignment = false;
            this.xrTableCell81.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft;
            this.xrTableCell81.Weight = 2.4026427586535095D;
            // 
            // xrTableRow23
            // 
            this.xrTableRow23.Cells.AddRange(new DevExpress.XtraReports.UI.XRTableCell[] {
            this.xrTableCell82,
            this.xrTableCell83,
            this.xrTableCell84});
            this.xrTableRow23.Name = "xrTableRow23";
            this.xrTableRow23.Weight = 0.41666778564453133D;
            // 
            // xrTableCell82
            // 
            this.xrTableCell82.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(211)))), ((int)(((byte)(203)))), ((int)(((byte)(200)))));
            this.xrTableCell82.Borders = DevExpress.XtraPrinting.BorderSide.Right;
            this.xrTableCell82.Name = "xrTableCell82";
            this.xrTableCell82.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrTableCell82.StylePriority.UseBorderColor = false;
            this.xrTableCell82.StylePriority.UseBorders = false;
            this.xrTableCell82.StylePriority.UsePadding = false;
            this.xrTableCell82.StylePriority.UseTextAlignment = false;
            this.xrTableCell82.Text = "xrTableCell31";
            this.xrTableCell82.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter;
            this.xrTableCell82.Weight = 0.10843551868807543D;
            // 
            // xrTableCell83
            // 
            this.xrTableCell83.Borders = ((DevExpress.XtraPrinting.BorderSide)(((DevExpress.XtraPrinting.BorderSide.Top | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTableCell83.BorderWidth = 1F;
            this.xrTableCell83.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrTableCell83.Name = "xrTableCell83";
            this.xrTableCell83.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrTableCell83.StylePriority.UseBorders = false;
            this.xrTableCell83.StylePriority.UseBorderWidth = false;
            this.xrTableCell83.StylePriority.UseFont = false;
            this.xrTableCell83.StylePriority.UsePadding = false;
            this.xrTableCell83.StylePriority.UseTextAlignment = false;
            this.xrTableCell83.Text = "사업장주소";
            this.xrTableCell83.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            this.xrTableCell83.Weight = 0.45680655963019279D;
            // 
            // xrTableCell84
            // 
            this.xrTableCell84.BackColor = System.Drawing.Color.White;
            this.xrTableCell84.BorderColor = System.Drawing.Color.Black;
            this.xrTableCell84.Borders = ((DevExpress.XtraPrinting.BorderSide)((DevExpress.XtraPrinting.BorderSide.Right | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTableCell84.BorderWidth = 1F;
            this.xrTableCell84.ExpressionBindings.AddRange(new DevExpress.XtraReports.UI.ExpressionBinding[] {
            new DevExpress.XtraReports.UI.ExpressionBinding("BeforePrint", "Text", "[COMPANY_ADDR]")});
            this.xrTableCell84.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrTableCell84.ForeColor = System.Drawing.Color.Black;
            this.xrTableCell84.Name = "xrTableCell84";
            this.xrTableCell84.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 0, 0, 0, 100F);
            this.xrTableCell84.StylePriority.UseBackColor = false;
            this.xrTableCell84.StylePriority.UseBorderColor = false;
            this.xrTableCell84.StylePriority.UseBorders = false;
            this.xrTableCell84.StylePriority.UseBorderWidth = false;
            this.xrTableCell84.StylePriority.UseFont = false;
            this.xrTableCell84.StylePriority.UseForeColor = false;
            this.xrTableCell84.StylePriority.UsePadding = false;
            this.xrTableCell84.StylePriority.UseTextAlignment = false;
            this.xrTableCell84.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft;
            this.xrTableCell84.Weight = 2.4026427586535095D;
            // 
            // lblDateTime
            // 
            this.lblDateTime.Borders = DevExpress.XtraPrinting.BorderSide.None;
            this.lblDateTime.ExpressionBindings.AddRange(new DevExpress.XtraReports.UI.ExpressionBinding[] {
            new DevExpress.XtraReports.UI.ExpressionBinding("BeforePrint", "Text", "[ENTRYDATE]")});
            this.lblDateTime.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.lblDateTime.LocationFloat = new DevExpress.Utils.PointFloat(580.8928F, 6.00001F);
            this.lblDateTime.Name = "lblDateTime";
            this.lblDateTime.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.lblDateTime.SizeF = new System.Drawing.SizeF(154.1069F, 23F);
            this.lblDateTime.StylePriority.UseBorders = false;
            this.lblDateTime.StylePriority.UseFont = false;
            this.lblDateTime.StylePriority.UseTextAlignment = false;
            this.lblDateTime.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleRight;
            this.lblDateTime.TextFormatString = "{0:yyyy\'년\' M\'월\' d\'일\'}";
            // 
            // xrTable2
            // 
            this.xrTable2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(229)))), ((int)(((byte)(224)))), ((int)(((byte)(220)))));
            this.xrTable2.Borders = DevExpress.XtraPrinting.BorderSide.None;
            this.xrTable2.BorderWidth = 0F;
            this.xrTable2.LocationFloat = new DevExpress.Utils.PointFloat(6.00001F, 350.9583F);
            this.xrTable2.Name = "xrTable2";
            this.xrTable2.Rows.AddRange(new DevExpress.XtraReports.UI.XRTableRow[] {
            this.xrTableRow9,
            this.xrTableRow10,
            this.xrTableRow4});
            this.xrTable2.SizeF = new System.Drawing.SizeF(731F, 93.75284F);
            this.xrTable2.StylePriority.UseBackColor = false;
            this.xrTable2.StylePriority.UseBorders = false;
            this.xrTable2.StylePriority.UseBorderWidth = false;
            // 
            // xrTableRow9
            // 
            this.xrTableRow9.Cells.AddRange(new DevExpress.XtraReports.UI.XRTableCell[] {
            this.xrTableCell39});
            this.xrTableRow9.Name = "xrTableRow9";
            this.xrTableRow9.Weight = 0.41666778564453133D;
            // 
            // xrTableCell39
            // 
            this.xrTableCell39.Borders = ((DevExpress.XtraPrinting.BorderSide)(((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Top) 
            | DevExpress.XtraPrinting.BorderSide.Right)));
            this.xrTableCell39.BorderWidth = 1F;
            this.xrTableCell39.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrTableCell39.Name = "xrTableCell39";
            this.xrTableCell39.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrTableCell39.StylePriority.UseBorders = false;
            this.xrTableCell39.StylePriority.UseBorderWidth = false;
            this.xrTableCell39.StylePriority.UseFont = false;
            this.xrTableCell39.StylePriority.UsePadding = false;
            this.xrTableCell39.StylePriority.UseTextAlignment = false;
            this.xrTableCell39.Text = "거래정보";
            this.xrTableCell39.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            this.xrTableCell39.Weight = 2.7534422612250813D;
            // 
            // xrTableRow10
            // 
            this.xrTableRow10.Cells.AddRange(new DevExpress.XtraReports.UI.XRTableCell[] {
            this.xrTableCell41,
            this.xrTableCell40,
            this.xrTableCell43,
            this.xrTableCell42});
            this.xrTableRow10.Name = "xrTableRow10";
            this.xrTableRow10.Weight = 0.41666778564453133D;
            // 
            // xrTableCell41
            // 
            this.xrTableCell41.Borders = ((DevExpress.XtraPrinting.BorderSide)((((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Top) 
            | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTableCell41.BorderWidth = 1F;
            this.xrTableCell41.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrTableCell41.Name = "xrTableCell41";
            this.xrTableCell41.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrTableCell41.StylePriority.UseBorders = false;
            this.xrTableCell41.StylePriority.UseBorderWidth = false;
            this.xrTableCell41.StylePriority.UseFont = false;
            this.xrTableCell41.StylePriority.UsePadding = false;
            this.xrTableCell41.StylePriority.UseTextAlignment = false;
            this.xrTableCell41.Text = "주문일자";
            this.xrTableCell41.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            this.xrTableCell41.Weight = 0.46760205444310615D;
            // 
            // xrTableCell40
            // 
            this.xrTableCell40.BackColor = System.Drawing.Color.White;
            this.xrTableCell40.BorderColor = System.Drawing.Color.Black;
            this.xrTableCell40.Borders = ((DevExpress.XtraPrinting.BorderSide)((((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Top) 
            | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTableCell40.BorderWidth = 1F;
            this.xrTableCell40.ExpressionBindings.AddRange(new DevExpress.XtraReports.UI.ExpressionBinding[] {
            new DevExpress.XtraReports.UI.ExpressionBinding("BeforePrint", "Text", "[ENTRYDATE]")});
            this.xrTableCell40.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrTableCell40.ForeColor = System.Drawing.Color.Black;
            this.xrTableCell40.Name = "xrTableCell40";
            this.xrTableCell40.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrTableCell40.StylePriority.UseBackColor = false;
            this.xrTableCell40.StylePriority.UseBorderColor = false;
            this.xrTableCell40.StylePriority.UseBorders = false;
            this.xrTableCell40.StylePriority.UseBorderWidth = false;
            this.xrTableCell40.StylePriority.UseFont = false;
            this.xrTableCell40.StylePriority.UseForeColor = false;
            this.xrTableCell40.StylePriority.UsePadding = false;
            this.xrTableCell40.StylePriority.UseTextAlignment = false;
            this.xrTableCell40.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            this.xrTableCell40.TextFormatString = "{0:yyyy-MM-dd}";
            this.xrTableCell40.Weight = 0.91082495692383192D;
            // 
            // xrTableCell43
            // 
            this.xrTableCell43.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(229)))), ((int)(((byte)(224)))), ((int)(((byte)(220)))));
            this.xrTableCell43.BorderColor = System.Drawing.Color.Black;
            this.xrTableCell43.Borders = ((DevExpress.XtraPrinting.BorderSide)((((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Top) 
            | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTableCell43.BorderWidth = 1F;
            this.xrTableCell43.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrTableCell43.Name = "xrTableCell43";
            this.xrTableCell43.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrTableCell43.StylePriority.UseBackColor = false;
            this.xrTableCell43.StylePriority.UseBorderColor = false;
            this.xrTableCell43.StylePriority.UseBorders = false;
            this.xrTableCell43.StylePriority.UseBorderWidth = false;
            this.xrTableCell43.StylePriority.UseFont = false;
            this.xrTableCell43.StylePriority.UsePadding = false;
            this.xrTableCell43.StylePriority.UseTextAlignment = false;
            this.xrTableCell43.Text = "주문번호";
            this.xrTableCell43.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            this.xrTableCell43.Weight = 0.46761434332209417D;
            // 
            // xrTableCell42
            // 
            this.xrTableCell42.BackColor = System.Drawing.Color.White;
            this.xrTableCell42.BorderColor = System.Drawing.Color.Black;
            this.xrTableCell42.Borders = ((DevExpress.XtraPrinting.BorderSide)((((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Top) 
            | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTableCell42.BorderWidth = 1F;
            this.xrTableCell42.ExpressionBindings.AddRange(new DevExpress.XtraReports.UI.ExpressionBinding[] {
            new DevExpress.XtraReports.UI.ExpressionBinding("BeforePrint", "Text", "[ORDERCODENO]")});
            this.xrTableCell42.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrTableCell42.Name = "xrTableCell42";
            this.xrTableCell42.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrTableCell42.StylePriority.UseBackColor = false;
            this.xrTableCell42.StylePriority.UseBorderColor = false;
            this.xrTableCell42.StylePriority.UseBorders = false;
            this.xrTableCell42.StylePriority.UseBorderWidth = false;
            this.xrTableCell42.StylePriority.UseFont = false;
            this.xrTableCell42.StylePriority.UsePadding = false;
            this.xrTableCell42.StylePriority.UseTextAlignment = false;
            this.xrTableCell42.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            this.xrTableCell42.Weight = 0.90740090653604955D;
            // 
            // xrTableRow4
            // 
            this.xrTableRow4.Cells.AddRange(new DevExpress.XtraReports.UI.XRTableCell[] {
            this.xrTableCell2,
            this.xrTableCell8});
            this.xrTableRow4.Name = "xrTableRow4";
            this.xrTableRow4.Weight = 0.41666778564453133D;
            // 
            // xrTableCell2
            // 
            this.xrTableCell2.Borders = ((DevExpress.XtraPrinting.BorderSide)(((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTableCell2.BorderWidth = 1F;
            this.xrTableCell2.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrTableCell2.Multiline = true;
            this.xrTableCell2.Name = "xrTableCell2";
            this.xrTableCell2.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrTableCell2.StylePriority.UseBorders = false;
            this.xrTableCell2.StylePriority.UseBorderWidth = false;
            this.xrTableCell2.StylePriority.UseFont = false;
            this.xrTableCell2.StylePriority.UsePadding = false;
            this.xrTableCell2.StylePriority.UseTextAlignment = false;
            this.xrTableCell2.Text = "주문정보";
            this.xrTableCell2.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            this.xrTableCell2.Weight = 0.46760205444310615D;
            // 
            // xrTableCell8
            // 
            this.xrTableCell8.BackColor = System.Drawing.Color.White;
            this.xrTableCell8.BorderColor = System.Drawing.Color.Black;
            this.xrTableCell8.Borders = ((DevExpress.XtraPrinting.BorderSide)(((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTableCell8.BorderWidth = 1F;
            this.xrTableCell8.ExpressionBindings.AddRange(new DevExpress.XtraReports.UI.ExpressionBinding[] {
            new DevExpress.XtraReports.UI.ExpressionBinding("BeforePrint", "Text", "Iif(Count() > 1, \'[\'+ [BRANDNAME]+ \']\' + [GOODSFINALNAME] + \' 외 \' + ToInt(Count()" +
                    "-1) + \'건\' + \'   (세부내역 참조)\', \'[\'+ [BRANDNAME]+ \']\' + [GOODSFINALNAME]\n)")});
            this.xrTableCell8.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrTableCell8.ForeColor = System.Drawing.Color.Black;
            this.xrTableCell8.Multiline = true;
            this.xrTableCell8.Name = "xrTableCell8";
            this.xrTableCell8.Padding = new DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 2, 100F);
            this.xrTableCell8.StylePriority.UseBackColor = false;
            this.xrTableCell8.StylePriority.UseBorderColor = false;
            this.xrTableCell8.StylePriority.UseBorders = false;
            this.xrTableCell8.StylePriority.UseBorderWidth = false;
            this.xrTableCell8.StylePriority.UseFont = false;
            this.xrTableCell8.StylePriority.UseForeColor = false;
            this.xrTableCell8.StylePriority.UsePadding = false;
            this.xrTableCell8.StylePriority.UseTextAlignment = false;
            this.xrTableCell8.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft;
            this.xrTableCell8.Weight = 2.2858402067819759D;
            // 
            // invoiceInfoTable
            // 
            this.invoiceInfoTable.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(229)))), ((int)(((byte)(224)))), ((int)(((byte)(220)))));
            this.invoiceInfoTable.Borders = ((DevExpress.XtraPrinting.BorderSide)((((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Top) 
            | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.invoiceInfoTable.LocationFloat = new DevExpress.Utils.PointFloat(6.00001F, 31.00001F);
            this.invoiceInfoTable.Name = "invoiceInfoTable";
            this.invoiceInfoTable.Rows.AddRange(new DevExpress.XtraReports.UI.XRTableRow[] {
            this.invoiceInfoTableRow2,
            this.invoiceInfoTableRow3,
            this.xrTableRow1,
            this.xrTableRow2,
            this.xrTableRow3});
            this.invoiceInfoTable.SizeF = new System.Drawing.SizeF(575.8188F, 157.2962F);
            this.invoiceInfoTable.StylePriority.UseBackColor = false;
            this.invoiceInfoTable.StylePriority.UseBorders = false;
            // 
            // invoiceInfoTableRow2
            // 
            this.invoiceInfoTableRow2.Cells.AddRange(new DevExpress.XtraReports.UI.XRTableCell[] {
            this.totalCaption2,
            this.invoiceDateCaption,
            this.xrTableCell34});
            this.invoiceInfoTableRow2.Name = "invoiceInfoTableRow2";
            this.invoiceInfoTableRow2.Weight = 0.4305545043945313D;
            // 
            // totalCaption2
            // 
            this.totalCaption2.BorderColor = System.Drawing.Color.Black;
            this.totalCaption2.Borders = ((DevExpress.XtraPrinting.BorderSide)((((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Top) 
            | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.totalCaption2.BorderWidth = 1F;
            this.totalCaption2.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.totalCaption2.ForeColor = System.Drawing.Color.Black;
            this.totalCaption2.Multiline = true;
            this.totalCaption2.Name = "totalCaption2";
            this.totalCaption2.RowSpan = 5;
            this.totalCaption2.StylePriority.UseBackColor = false;
            this.totalCaption2.StylePriority.UseBorderColor = false;
            this.totalCaption2.StylePriority.UseBorders = false;
            this.totalCaption2.StylePriority.UseBorderWidth = false;
            this.totalCaption2.StylePriority.UseFont = false;
            this.totalCaption2.StylePriority.UseForeColor = false;
            this.totalCaption2.StylePriority.UseTextAlignment = false;
            this.totalCaption2.Text = "공\r\n급\r\n자";
            this.totalCaption2.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            this.totalCaption2.Weight = 0.10813869605803178D;
            // 
            // invoiceDateCaption
            // 
            this.invoiceDateCaption.Borders = ((DevExpress.XtraPrinting.BorderSide)(((DevExpress.XtraPrinting.BorderSide.Top | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.invoiceDateCaption.BorderWidth = 1F;
            this.invoiceDateCaption.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.invoiceDateCaption.ForeColor = System.Drawing.Color.Black;
            this.invoiceDateCaption.Name = "invoiceDateCaption";
            this.invoiceDateCaption.StylePriority.UseBackColor = false;
            this.invoiceDateCaption.StylePriority.UseBorders = false;
            this.invoiceDateCaption.StylePriority.UseBorderWidth = false;
            this.invoiceDateCaption.StylePriority.UseFont = false;
            this.invoiceDateCaption.StylePriority.UseForeColor = false;
            this.invoiceDateCaption.StylePriority.UseTextAlignment = false;
            this.invoiceDateCaption.Text = "사업자등록번호";
            this.invoiceDateCaption.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            this.invoiceDateCaption.Weight = 0.45555675701201193D;
            // 
            // xrTableCell34
            // 
            this.xrTableCell34.BackColor = System.Drawing.Color.White;
            this.xrTableCell34.BorderColor = System.Drawing.Color.Black;
            this.xrTableCell34.Borders = ((DevExpress.XtraPrinting.BorderSide)((DevExpress.XtraPrinting.BorderSide.Top | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTableCell34.BorderWidth = 1F;
            this.xrTableCell34.ExpressionBindings.AddRange(new DevExpress.XtraReports.UI.ExpressionBinding[] {
            new DevExpress.XtraReports.UI.ExpressionBinding("BeforePrint", "Text", "[ORDERSALECOMPANY_NO]")});
            this.xrTableCell34.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrTableCell34.Name = "xrTableCell34";
            this.xrTableCell34.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 0, 0, 0, 100F);
            this.xrTableCell34.StylePriority.UseBackColor = false;
            this.xrTableCell34.StylePriority.UseBorderColor = false;
            this.xrTableCell34.StylePriority.UseBorders = false;
            this.xrTableCell34.StylePriority.UseBorderWidth = false;
            this.xrTableCell34.StylePriority.UseFont = false;
            this.xrTableCell34.StylePriority.UseForeColor = false;
            this.xrTableCell34.StylePriority.UsePadding = false;
            this.xrTableCell34.StylePriority.UseTextAlignment = false;
            this.xrTableCell34.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft;
            this.xrTableCell34.Weight = 1.7677513206771522D;
            // 
            // invoiceInfoTableRow3
            // 
            this.invoiceInfoTableRow3.Cells.AddRange(new DevExpress.XtraReports.UI.XRTableCell[] {
            this.total2,
            this.invoiceDate,
            this.xrTableCell35});
            this.invoiceInfoTableRow3.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Bold);
            this.invoiceInfoTableRow3.Name = "invoiceInfoTableRow3";
            this.invoiceInfoTableRow3.StylePriority.UseFont = false;
            this.invoiceInfoTableRow3.Weight = 0.41666778564453133D;
            // 
            // total2
            // 
            this.total2.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(211)))), ((int)(((byte)(203)))), ((int)(((byte)(200)))));
            this.total2.Borders = DevExpress.XtraPrinting.BorderSide.Right;
            this.total2.Multiline = true;
            this.total2.Name = "total2";
            this.total2.StylePriority.UseBackColor = false;
            this.total2.StylePriority.UseBorderColor = false;
            this.total2.StylePriority.UseBorders = false;
            this.total2.StylePriority.UseFont = false;
            this.total2.StylePriority.UseTextAlignment = false;
            this.total2.Text = "\r\n";
            this.total2.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter;
            this.total2.TextFormatString = "{0:$0.00}";
            this.total2.Weight = 0.10813870407542227D;
            // 
            // invoiceDate
            // 
            this.invoiceDate.Borders = ((DevExpress.XtraPrinting.BorderSide)((DevExpress.XtraPrinting.BorderSide.Right | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.invoiceDate.BorderWidth = 1F;
            this.invoiceDate.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.invoiceDate.Name = "invoiceDate";
            this.invoiceDate.StylePriority.UseBackColor = false;
            this.invoiceDate.StylePriority.UseBorders = false;
            this.invoiceDate.StylePriority.UseBorderWidth = false;
            this.invoiceDate.StylePriority.UseFont = false;
            this.invoiceDate.StylePriority.UseTextAlignment = false;
            this.invoiceDate.Text = "상호(법인명)";
            this.invoiceDate.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            this.invoiceDate.TextFormatString = "{0:dd MMM yy}";
            this.invoiceDate.Weight = 0.45555674899462151D;
            // 
            // xrTableCell35
            // 
            this.xrTableCell35.BackColor = System.Drawing.Color.White;
            this.xrTableCell35.BorderColor = System.Drawing.Color.Black;
            this.xrTableCell35.Borders = DevExpress.XtraPrinting.BorderSide.Bottom;
            this.xrTableCell35.BorderWidth = 1F;
            this.xrTableCell35.ExpressionBindings.AddRange(new DevExpress.XtraReports.UI.ExpressionBinding[] {
            new DevExpress.XtraReports.UI.ExpressionBinding("BeforePrint", "Text", "[ORDERSALECOMPANY_NAME]")});
            this.xrTableCell35.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrTableCell35.ForeColor = System.Drawing.Color.Black;
            this.xrTableCell35.Name = "xrTableCell35";
            this.xrTableCell35.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 0, 0, 0, 100F);
            this.xrTableCell35.StylePriority.UseBackColor = false;
            this.xrTableCell35.StylePriority.UseBorderColor = false;
            this.xrTableCell35.StylePriority.UseBorders = false;
            this.xrTableCell35.StylePriority.UseBorderWidth = false;
            this.xrTableCell35.StylePriority.UseFont = false;
            this.xrTableCell35.StylePriority.UseForeColor = false;
            this.xrTableCell35.StylePriority.UsePadding = false;
            this.xrTableCell35.StylePriority.UseTextAlignment = false;
            this.xrTableCell35.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft;
            this.xrTableCell35.Weight = 1.7677513206771522D;
            // 
            // xrTableRow1
            // 
            this.xrTableRow1.Cells.AddRange(new DevExpress.XtraReports.UI.XRTableCell[] {
            this.xrTableCell10,
            this.xrTableCell11,
            this.xrTableCell36});
            this.xrTableRow1.Name = "xrTableRow1";
            this.xrTableRow1.Weight = 0.41666778564453133D;
            // 
            // xrTableCell10
            // 
            this.xrTableCell10.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(211)))), ((int)(((byte)(203)))), ((int)(((byte)(200)))));
            this.xrTableCell10.Borders = DevExpress.XtraPrinting.BorderSide.Right;
            this.xrTableCell10.Name = "xrTableCell10";
            this.xrTableCell10.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrTableCell10.StylePriority.UseBorderColor = false;
            this.xrTableCell10.StylePriority.UseBorders = false;
            this.xrTableCell10.StylePriority.UseTextAlignment = false;
            this.xrTableCell10.Text = "xrTableCell10";
            this.xrTableCell10.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter;
            this.xrTableCell10.Weight = 0.10813870407542227D;
            // 
            // xrTableCell11
            // 
            this.xrTableCell11.Borders = ((DevExpress.XtraPrinting.BorderSide)((DevExpress.XtraPrinting.BorderSide.Right | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTableCell11.BorderWidth = 1F;
            this.xrTableCell11.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrTableCell11.Name = "xrTableCell11";
            this.xrTableCell11.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrTableCell11.StylePriority.UseBorders = false;
            this.xrTableCell11.StylePriority.UseBorderWidth = false;
            this.xrTableCell11.StylePriority.UseFont = false;
            this.xrTableCell11.StylePriority.UseTextAlignment = false;
            this.xrTableCell11.Text = "성명(대표자명)";
            this.xrTableCell11.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            this.xrTableCell11.Weight = 0.45555674899462151D;
            // 
            // xrTableCell36
            // 
            this.xrTableCell36.BackColor = System.Drawing.Color.White;
            this.xrTableCell36.BorderColor = System.Drawing.Color.Black;
            this.xrTableCell36.Borders = DevExpress.XtraPrinting.BorderSide.Bottom;
            this.xrTableCell36.BorderWidth = 1F;
            this.xrTableCell36.ExpressionBindings.AddRange(new DevExpress.XtraReports.UI.ExpressionBinding[] {
            new DevExpress.XtraReports.UI.ExpressionBinding("BeforePrint", "Text", "[ORDERSALECOMPANY_DELEGATENAME]")});
            this.xrTableCell36.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrTableCell36.ForeColor = System.Drawing.Color.Black;
            this.xrTableCell36.Name = "xrTableCell36";
            this.xrTableCell36.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 0, 0, 0, 100F);
            this.xrTableCell36.StylePriority.UseBackColor = false;
            this.xrTableCell36.StylePriority.UseBorderColor = false;
            this.xrTableCell36.StylePriority.UseBorders = false;
            this.xrTableCell36.StylePriority.UseBorderWidth = false;
            this.xrTableCell36.StylePriority.UseFont = false;
            this.xrTableCell36.StylePriority.UseForeColor = false;
            this.xrTableCell36.StylePriority.UsePadding = false;
            this.xrTableCell36.StylePriority.UseTextAlignment = false;
            this.xrTableCell36.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft;
            this.xrTableCell36.Weight = 1.7677513206771522D;
            // 
            // xrTableRow2
            // 
            this.xrTableRow2.Cells.AddRange(new DevExpress.XtraReports.UI.XRTableCell[] {
            this.xrTableCell13,
            this.xrTableCell14,
            this.xrTableCell37});
            this.xrTableRow2.Name = "xrTableRow2";
            this.xrTableRow2.Weight = 0.41666778564453133D;
            // 
            // xrTableCell13
            // 
            this.xrTableCell13.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(211)))), ((int)(((byte)(203)))), ((int)(((byte)(200)))));
            this.xrTableCell13.Borders = DevExpress.XtraPrinting.BorderSide.Right;
            this.xrTableCell13.Name = "xrTableCell13";
            this.xrTableCell13.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrTableCell13.StylePriority.UseBorderColor = false;
            this.xrTableCell13.StylePriority.UseBorders = false;
            this.xrTableCell13.StylePriority.UsePadding = false;
            this.xrTableCell13.StylePriority.UseTextAlignment = false;
            this.xrTableCell13.Text = "xrTableCell13";
            this.xrTableCell13.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter;
            this.xrTableCell13.Weight = 0.10813870407542227D;
            // 
            // xrTableCell14
            // 
            this.xrTableCell14.Borders = ((DevExpress.XtraPrinting.BorderSide)((DevExpress.XtraPrinting.BorderSide.Right | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTableCell14.BorderWidth = 1F;
            this.xrTableCell14.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrTableCell14.Name = "xrTableCell14";
            this.xrTableCell14.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrTableCell14.StylePriority.UseBorders = false;
            this.xrTableCell14.StylePriority.UseBorderWidth = false;
            this.xrTableCell14.StylePriority.UseFont = false;
            this.xrTableCell14.StylePriority.UsePadding = false;
            this.xrTableCell14.StylePriority.UseTextAlignment = false;
            this.xrTableCell14.Text = "전화번호";
            this.xrTableCell14.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            this.xrTableCell14.Weight = 0.45555674899462151D;
            // 
            // xrTableCell37
            // 
            this.xrTableCell37.BackColor = System.Drawing.Color.White;
            this.xrTableCell37.BorderColor = System.Drawing.Color.Black;
            this.xrTableCell37.Borders = DevExpress.XtraPrinting.BorderSide.Bottom;
            this.xrTableCell37.BorderWidth = 1F;
            this.xrTableCell37.ExpressionBindings.AddRange(new DevExpress.XtraReports.UI.ExpressionBinding[] {
            new DevExpress.XtraReports.UI.ExpressionBinding("BeforePrint", "Text", "[ORDERSALECOMPANY_TEL]")});
            this.xrTableCell37.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrTableCell37.ForeColor = System.Drawing.Color.Black;
            this.xrTableCell37.Name = "xrTableCell37";
            this.xrTableCell37.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 0, 0, 0, 100F);
            this.xrTableCell37.StylePriority.UseBackColor = false;
            this.xrTableCell37.StylePriority.UseBorderColor = false;
            this.xrTableCell37.StylePriority.UseBorders = false;
            this.xrTableCell37.StylePriority.UseBorderWidth = false;
            this.xrTableCell37.StylePriority.UseFont = false;
            this.xrTableCell37.StylePriority.UseForeColor = false;
            this.xrTableCell37.StylePriority.UsePadding = false;
            this.xrTableCell37.StylePriority.UseTextAlignment = false;
            this.xrTableCell37.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft;
            this.xrTableCell37.Weight = 1.7677513206771522D;
            // 
            // xrTableRow3
            // 
            this.xrTableRow3.Cells.AddRange(new DevExpress.XtraReports.UI.XRTableCell[] {
            this.xrTableCell16,
            this.xrTableCell17,
            this.xrTableCell38});
            this.xrTableRow3.Name = "xrTableRow3";
            this.xrTableRow3.Weight = 0.41666778564453133D;
            // 
            // xrTableCell16
            // 
            this.xrTableCell16.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(211)))), ((int)(((byte)(203)))), ((int)(((byte)(200)))));
            this.xrTableCell16.Borders = DevExpress.XtraPrinting.BorderSide.Right;
            this.xrTableCell16.Name = "xrTableCell16";
            this.xrTableCell16.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrTableCell16.StylePriority.UseBorderColor = false;
            this.xrTableCell16.StylePriority.UseBorders = false;
            this.xrTableCell16.StylePriority.UsePadding = false;
            this.xrTableCell16.StylePriority.UseTextAlignment = false;
            this.xrTableCell16.Text = "xrTableCell16";
            this.xrTableCell16.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopCenter;
            this.xrTableCell16.Weight = 0.10813870407542227D;
            // 
            // xrTableCell17
            // 
            this.xrTableCell17.Borders = ((DevExpress.XtraPrinting.BorderSide)((DevExpress.XtraPrinting.BorderSide.Right | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTableCell17.BorderWidth = 1F;
            this.xrTableCell17.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrTableCell17.Name = "xrTableCell17";
            this.xrTableCell17.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrTableCell17.StylePriority.UseBorders = false;
            this.xrTableCell17.StylePriority.UseBorderWidth = false;
            this.xrTableCell17.StylePriority.UseFont = false;
            this.xrTableCell17.StylePriority.UsePadding = false;
            this.xrTableCell17.StylePriority.UseTextAlignment = false;
            this.xrTableCell17.Text = "사업장주소";
            this.xrTableCell17.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            this.xrTableCell17.Weight = 0.45555674899462151D;
            // 
            // xrTableCell38
            // 
            this.xrTableCell38.BackColor = System.Drawing.Color.White;
            this.xrTableCell38.BorderColor = System.Drawing.Color.Black;
            this.xrTableCell38.Borders = DevExpress.XtraPrinting.BorderSide.Bottom;
            this.xrTableCell38.BorderWidth = 1F;
            this.xrTableCell38.ExpressionBindings.AddRange(new DevExpress.XtraReports.UI.ExpressionBinding[] {
            new DevExpress.XtraReports.UI.ExpressionBinding("BeforePrint", "Text", "[ORDERSALECOMPANY_ADDR]")});
            this.xrTableCell38.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrTableCell38.ForeColor = System.Drawing.Color.Black;
            this.xrTableCell38.Name = "xrTableCell38";
            this.xrTableCell38.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 0, 0, 0, 100F);
            this.xrTableCell38.StylePriority.UseBackColor = false;
            this.xrTableCell38.StylePriority.UseBorderColor = false;
            this.xrTableCell38.StylePriority.UseBorders = false;
            this.xrTableCell38.StylePriority.UseBorderWidth = false;
            this.xrTableCell38.StylePriority.UseFont = false;
            this.xrTableCell38.StylePriority.UseForeColor = false;
            this.xrTableCell38.StylePriority.UsePadding = false;
            this.xrTableCell38.StylePriority.UseTextAlignment = false;
            this.xrTableCell38.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft;
            this.xrTableCell38.Weight = 1.7677513206771522D;
            // 
            // GroupFooter1
            // 
            this.GroupFooter1.Controls.AddRange(new DevExpress.XtraReports.UI.XRControl[] {
            this.xrTable4,
            this.xrPanel1,
            this.xrTable1});
            this.GroupFooter1.GroupUnion = DevExpress.XtraReports.UI.GroupFooterUnion.WithLastDetail;
            this.GroupFooter1.HeightF = 379.7977F;
            this.GroupFooter1.KeepTogether = true;
            this.GroupFooter1.Name = "GroupFooter1";
            this.GroupFooter1.StyleName = "baseControlStyle";
            // 
            // xrTable4
            // 
            this.xrTable4.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(229)))), ((int)(((byte)(224)))), ((int)(((byte)(220)))));
            this.xrTable4.BorderColor = System.Drawing.Color.Black;
            this.xrTable4.Font = new System.Drawing.Font("Segoe UI", 9.75F, System.Drawing.FontStyle.Bold);
            this.xrTable4.LocationFloat = new DevExpress.Utils.PointFloat(6.00001F, 220.4194F);
            this.xrTable4.Name = "xrTable4";
            this.xrTable4.Padding = new DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 100F);
            this.xrTable4.Rows.AddRange(new DevExpress.XtraReports.UI.XRTableRow[] {
            this.xrTableRow5});
            this.xrTable4.SizeF = new System.Drawing.SizeF(730.9998F, 159.3782F);
            this.xrTable4.StylePriority.UseBackColor = false;
            this.xrTable4.StylePriority.UseBorderColor = false;
            this.xrTable4.StylePriority.UseBorders = false;
            this.xrTable4.StylePriority.UseFont = false;
            this.xrTable4.StylePriority.UsePadding = false;
            // 
            // xrTableRow5
            // 
            this.xrTableRow5.Cells.AddRange(new DevExpress.XtraReports.UI.XRTableCell[] {
            this.xrTableCell12});
            this.xrTableRow5.Name = "xrTableRow5";
            this.xrTableRow5.Weight = 10.58D;
            // 
            // xrTableCell12
            // 
            this.xrTableCell12.BackColor = System.Drawing.Color.White;
            this.xrTableCell12.BorderColor = System.Drawing.Color.Black;
            this.xrTableCell12.Borders = ((DevExpress.XtraPrinting.BorderSide)(((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTableCell12.BorderWidth = 1F;
            this.xrTableCell12.Font = new System.Drawing.Font("맑은 고딕", 9.75F, System.Drawing.FontStyle.Bold);
            this.xrTableCell12.Multiline = true;
            this.xrTableCell12.Name = "xrTableCell12";
            this.xrTableCell12.Padding = new DevExpress.XtraPrinting.PaddingInfo(250, 0, 0, 0, 100F);
            this.xrTableCell12.StylePriority.UseBackColor = false;
            this.xrTableCell12.StylePriority.UseBorderColor = false;
            this.xrTableCell12.StylePriority.UseBorders = false;
            this.xrTableCell12.StylePriority.UseBorderWidth = false;
            this.xrTableCell12.StylePriority.UseFont = false;
            this.xrTableCell12.StylePriority.UsePadding = false;
            this.xrTableCell12.StylePriority.UseTextAlignment = false;
            this.xrTableCell12.Text = "     -사회적 경제 윤리헌장-\r\n\r\n품질: 품질로 국가경제에 기여\r\n공존: 공존하는 방향으로 사업수행\r\n공정: 공정한 운영으로 소비자 주권보호" +
    "\r\n지속: 지속가능한 사업모델 구축\r\n투명: 투명한 거래로 청렴사회 구현";
            this.xrTableCell12.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft;
            this.xrTableCell12.Weight = 1.0247459495309381D;
            // 
            // xrPanel1
            // 
            this.xrPanel1.Borders = ((DevExpress.XtraPrinting.BorderSide)(((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrPanel1.Controls.AddRange(new DevExpress.XtraReports.UI.XRControl[] {
            this.xrLabel8,
            this.xrLabel7,
            this.xrLabel6,
            this.xrLabel5,
            this.xrLabel4,
            this.xrLabel3,
            this.xrLabel2});
            this.xrPanel1.LocationFloat = new DevExpress.Utils.PointFloat(6.000233F, 103.7528F);
            this.xrPanel1.Name = "xrPanel1";
            this.xrPanel1.SizeF = new System.Drawing.SizeF(730.9996F, 116.6667F);
            this.xrPanel1.StylePriority.UseBorders = false;
            // 
            // xrLabel8
            // 
            this.xrLabel8.Borders = DevExpress.XtraPrinting.BorderSide.None;
            this.xrLabel8.ExpressionBindings.AddRange(new DevExpress.XtraReports.UI.ExpressionBinding[] {
            new DevExpress.XtraReports.UI.ExpressionBinding("BeforePrint", "Text", "[BUYERTELNO]")});
            this.xrLabel8.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrLabel8.LocationFloat = new DevExpress.Utils.PointFloat(109.9999F, 84.00002F);
            this.xrLabel8.Name = "xrLabel8";
            this.xrLabel8.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrLabel8.SizeF = new System.Drawing.SizeF(608.9997F, 23.00002F);
            this.xrLabel8.StylePriority.UseBorders = false;
            this.xrLabel8.StylePriority.UseFont = false;
            this.xrLabel8.StylePriority.UseTextAlignment = false;
            this.xrLabel8.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft;
            // 
            // xrLabel7
            // 
            this.xrLabel7.Borders = DevExpress.XtraPrinting.BorderSide.None;
            this.xrLabel7.ExpressionBindings.AddRange(new DevExpress.XtraReports.UI.ExpressionBinding[] {
            new DevExpress.XtraReports.UI.ExpressionBinding("BeforePrint", "Text", "[BUYERADDRESS]")});
            this.xrLabel7.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrLabel7.LocationFloat = new DevExpress.Utils.PointFloat(110F, 59.99997F);
            this.xrLabel7.Name = "xrLabel7";
            this.xrLabel7.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrLabel7.SizeF = new System.Drawing.SizeF(608.9996F, 23F);
            this.xrLabel7.StylePriority.UseBorders = false;
            this.xrLabel7.StylePriority.UseFont = false;
            this.xrLabel7.StylePriority.UseTextAlignment = false;
            this.xrLabel7.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft;
            // 
            // xrLabel6
            // 
            this.xrLabel6.Borders = DevExpress.XtraPrinting.BorderSide.None;
            this.xrLabel6.ExpressionBindings.AddRange(new DevExpress.XtraReports.UI.ExpressionBinding[] {
            new DevExpress.XtraReports.UI.ExpressionBinding("BeforePrint", "Text", "[BUYERNAME]")});
            this.xrLabel6.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrLabel6.LocationFloat = new DevExpress.Utils.PointFloat(110F, 36F);
            this.xrLabel6.Name = "xrLabel6";
            this.xrLabel6.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrLabel6.SizeF = new System.Drawing.SizeF(608.9996F, 23F);
            this.xrLabel6.StylePriority.UseBorders = false;
            this.xrLabel6.StylePriority.UseFont = false;
            this.xrLabel6.StylePriority.UseTextAlignment = false;
            this.xrLabel6.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft;
            // 
            // xrLabel5
            // 
            this.xrLabel5.Borders = DevExpress.XtraPrinting.BorderSide.None;
            this.xrLabel5.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrLabel5.LocationFloat = new DevExpress.Utils.PointFloat(10.00001F, 84.00001F);
            this.xrLabel5.Multiline = true;
            this.xrLabel5.Name = "xrLabel5";
            this.xrLabel5.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrLabel5.SizeF = new System.Drawing.SizeF(100F, 23F);
            this.xrLabel5.StylePriority.UseBorders = false;
            this.xrLabel5.StylePriority.UseFont = false;
            this.xrLabel5.StylePriority.UseTextAlignment = false;
            this.xrLabel5.Text = "담당 연락처 :";
            this.xrLabel5.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft;
            // 
            // xrLabel4
            // 
            this.xrLabel4.Borders = DevExpress.XtraPrinting.BorderSide.None;
            this.xrLabel4.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrLabel4.LocationFloat = new DevExpress.Utils.PointFloat(10.00001F, 59.99999F);
            this.xrLabel4.Multiline = true;
            this.xrLabel4.Name = "xrLabel4";
            this.xrLabel4.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrLabel4.SizeF = new System.Drawing.SizeF(100F, 23F);
            this.xrLabel4.StylePriority.UseBorders = false;
            this.xrLabel4.StylePriority.UseFont = false;
            this.xrLabel4.StylePriority.UseTextAlignment = false;
            this.xrLabel4.Text = "주문 장소 :";
            this.xrLabel4.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft;
            // 
            // xrLabel3
            // 
            this.xrLabel3.Borders = DevExpress.XtraPrinting.BorderSide.None;
            this.xrLabel3.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrLabel3.LocationFloat = new DevExpress.Utils.PointFloat(10.00001F, 35.99999F);
            this.xrLabel3.Multiline = true;
            this.xrLabel3.Name = "xrLabel3";
            this.xrLabel3.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrLabel3.SizeF = new System.Drawing.SizeF(100F, 23F);
            this.xrLabel3.StylePriority.UseBorders = false;
            this.xrLabel3.StylePriority.UseFont = false;
            this.xrLabel3.StylePriority.UseTextAlignment = false;
            this.xrLabel3.Text = "담당자 명 : ";
            this.xrLabel3.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft;
            // 
            // xrLabel2
            // 
            this.xrLabel2.Borders = DevExpress.XtraPrinting.BorderSide.None;
            this.xrLabel2.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrLabel2.LocationFloat = new DevExpress.Utils.PointFloat(10.00001F, 9.999974F);
            this.xrLabel2.Multiline = true;
            this.xrLabel2.Name = "xrLabel2";
            this.xrLabel2.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrLabel2.SizeF = new System.Drawing.SizeF(113.9276F, 23F);
            this.xrLabel2.StylePriority.UseBorders = false;
            this.xrLabel2.StylePriority.UseFont = false;
            this.xrLabel2.StylePriority.UseTextAlignment = false;
            this.xrLabel2.Text = "※ 주문자 정보\r\n";
            this.xrLabel2.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleLeft;
            // 
            // xrTable1
            // 
            this.xrTable1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(229)))), ((int)(((byte)(224)))), ((int)(((byte)(220)))));
            this.xrTable1.Borders = DevExpress.XtraPrinting.BorderSide.None;
            this.xrTable1.LocationFloat = new DevExpress.Utils.PointFloat(6.00001F, 10.00001F);
            this.xrTable1.Name = "xrTable1";
            this.xrTable1.Rows.AddRange(new DevExpress.XtraReports.UI.XRTableRow[] {
            this.xrTableRow14,
            this.xrTableRow15,
            this.xrTableRow16});
            this.xrTable1.SizeF = new System.Drawing.SizeF(731F, 93.75282F);
            this.xrTable1.StylePriority.UseBackColor = false;
            this.xrTable1.StylePriority.UseBorders = false;
            // 
            // xrTableRow14
            // 
            this.xrTableRow14.Cells.AddRange(new DevExpress.XtraReports.UI.XRTableCell[] {
            this.xrTableCell60,
            this.xrTableCell61});
            this.xrTableRow14.Name = "xrTableRow14";
            this.xrTableRow14.Weight = 0.41666778564453133D;
            // 
            // xrTableCell60
            // 
            this.xrTableCell60.Borders = ((DevExpress.XtraPrinting.BorderSide)(((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Top) 
            | DevExpress.XtraPrinting.BorderSide.Right)));
            this.xrTableCell60.BorderWidth = 1F;
            this.xrTableCell60.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrTableCell60.Name = "xrTableCell60";
            this.xrTableCell60.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrTableCell60.StylePriority.UseBorders = false;
            this.xrTableCell60.StylePriority.UseBorderWidth = false;
            this.xrTableCell60.StylePriority.UseFont = false;
            this.xrTableCell60.StylePriority.UsePadding = false;
            this.xrTableCell60.StylePriority.UseTextAlignment = false;
            this.xrTableCell60.Text = "합계금액(VAT포함)";
            this.xrTableCell60.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            this.xrTableCell60.Weight = 1.0025293421316008D;
            // 
            // xrTableCell61
            // 
            this.xrTableCell61.BackColor = System.Drawing.Color.White;
            this.xrTableCell61.BorderColor = System.Drawing.Color.Black;
            this.xrTableCell61.Borders = ((DevExpress.XtraPrinting.BorderSide)(((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Top) 
            | DevExpress.XtraPrinting.BorderSide.Right)));
            this.xrTableCell61.BorderWidth = 1F;
            this.xrTableCell61.ExpressionBindings.AddRange(new DevExpress.XtraReports.UI.ExpressionBinding[] {
            new DevExpress.XtraReports.UI.ExpressionBinding("BeforePrint", "Text", "Sum([GOODSTOTALSALEPRICEVAT])")});
            this.xrTableCell61.Font = new System.Drawing.Font("맑은 고딕", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.xrTableCell61.Name = "xrTableCell61";
            this.xrTableCell61.Padding = new DevExpress.XtraPrinting.PaddingInfo(0, 30, 0, 0, 100F);
            this.xrTableCell61.StylePriority.UseBackColor = false;
            this.xrTableCell61.StylePriority.UseBorderColor = false;
            this.xrTableCell61.StylePriority.UseBorders = false;
            this.xrTableCell61.StylePriority.UseBorderWidth = false;
            this.xrTableCell61.StylePriority.UseFont = false;
            this.xrTableCell61.StylePriority.UsePadding = false;
            this.xrTableCell61.StylePriority.UseTextAlignment = false;
            this.xrTableCell61.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleRight;
            this.xrTableCell61.TextFormatString = "{0:n0}원";
            this.xrTableCell61.Weight = 1.7509129190934805D;
            // 
            // xrTableRow15
            // 
            this.xrTableRow15.Cells.AddRange(new DevExpress.XtraReports.UI.XRTableCell[] {
            this.xrTableCell63,
            this.xrTableCell64});
            this.xrTableRow15.Name = "xrTableRow15";
            this.xrTableRow15.Weight = 0.41666778564453133D;
            // 
            // xrTableCell63
            // 
            this.xrTableCell63.Borders = ((DevExpress.XtraPrinting.BorderSide)(((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Top) 
            | DevExpress.XtraPrinting.BorderSide.Right)));
            this.xrTableCell63.BorderWidth = 1F;
            this.xrTableCell63.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrTableCell63.Name = "xrTableCell63";
            this.xrTableCell63.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrTableCell63.StylePriority.UseBorders = false;
            this.xrTableCell63.StylePriority.UseBorderWidth = false;
            this.xrTableCell63.StylePriority.UseFont = false;
            this.xrTableCell63.StylePriority.UsePadding = false;
            this.xrTableCell63.StylePriority.UseTextAlignment = false;
            this.xrTableCell63.Text = "배송비 + 특수배송비금액";
            this.xrTableCell63.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            this.xrTableCell63.Weight = 1.0025293421316008D;
            // 
            // xrTableCell64
            // 
            this.xrTableCell64.BackColor = System.Drawing.Color.White;
            this.xrTableCell64.BorderColor = System.Drawing.Color.Black;
            this.xrTableCell64.Borders = ((DevExpress.XtraPrinting.BorderSide)(((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Top) 
            | DevExpress.XtraPrinting.BorderSide.Right)));
            this.xrTableCell64.BorderWidth = 1F;
            this.xrTableCell64.ExpressionBindings.AddRange(new DevExpress.XtraReports.UI.ExpressionBinding[] {
            new DevExpress.XtraReports.UI.ExpressionBinding("BeforePrint", "Text", "Iif(Sum([GOODSTOTALSALEPRICEVAT]) > 50000,ToDecimal([POWER_DELIVERYCOST]),\nToDeci" +
                    "mal([POWER_DELIVERYCOST])+ToDecimal([DEFAULT_DELIVERYCOST]))")});
            this.xrTableCell64.Font = new System.Drawing.Font("맑은 고딕", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.xrTableCell64.Name = "xrTableCell64";
            this.xrTableCell64.Padding = new DevExpress.XtraPrinting.PaddingInfo(0, 30, 0, 0, 100F);
            this.xrTableCell64.StylePriority.UseBackColor = false;
            this.xrTableCell64.StylePriority.UseBorderColor = false;
            this.xrTableCell64.StylePriority.UseBorders = false;
            this.xrTableCell64.StylePriority.UseBorderWidth = false;
            this.xrTableCell64.StylePriority.UseFont = false;
            this.xrTableCell64.StylePriority.UsePadding = false;
            this.xrTableCell64.StylePriority.UseTextAlignment = false;
            this.xrTableCell64.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleRight;
            this.xrTableCell64.TextFormatString = "{0:n0}원";
            this.xrTableCell64.Weight = 1.7509129190934805D;
            // 
            // xrTableRow16
            // 
            this.xrTableRow16.Cells.AddRange(new DevExpress.XtraReports.UI.XRTableCell[] {
            this.xrTableCell66,
            this.xrTableCell67});
            this.xrTableRow16.Name = "xrTableRow16";
            this.xrTableRow16.Weight = 0.41666778564453133D;
            // 
            // xrTableCell66
            // 
            this.xrTableCell66.Borders = ((DevExpress.XtraPrinting.BorderSide)((((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Top) 
            | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTableCell66.BorderWidth = 1F;
            this.xrTableCell66.Font = new System.Drawing.Font("맑은 고딕", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.xrTableCell66.Name = "xrTableCell66";
            this.xrTableCell66.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrTableCell66.StylePriority.UseBorders = false;
            this.xrTableCell66.StylePriority.UseBorderWidth = false;
            this.xrTableCell66.StylePriority.UseFont = false;
            this.xrTableCell66.StylePriority.UsePadding = false;
            this.xrTableCell66.StylePriority.UseTextAlignment = false;
            this.xrTableCell66.Text = "총합계금액(VAT포함)";
            this.xrTableCell66.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            this.xrTableCell66.Weight = 1.0025293421316008D;
            // 
            // xrTableCell67
            // 
            this.xrTableCell67.BackColor = System.Drawing.Color.White;
            this.xrTableCell67.BorderColor = System.Drawing.Color.Black;
            this.xrTableCell67.Borders = ((DevExpress.XtraPrinting.BorderSide)((((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Top) 
            | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTableCell67.BorderWidth = 1F;
            this.xrTableCell67.ExpressionBindings.AddRange(new DevExpress.XtraReports.UI.ExpressionBinding[] {
            new DevExpress.XtraReports.UI.ExpressionBinding("BeforePrint", "Text", "ToDecimal(Sum([GOODSTOTALSALEPRICEVAT]))  + ToDecimal(Iif(Sum([GOODSTOTALSALEPRIC" +
                    "EVAT]) > 50000, ToDecimal([POWER_DELIVERYCOST]),\n  ToDecimal([DEFAULT_DELIVERYCO" +
                    "ST])+ToDecimal([POWER_DELIVERYCOST])))")});
            this.xrTableCell67.Font = new System.Drawing.Font("맑은 고딕", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.xrTableCell67.Name = "xrTableCell67";
            this.xrTableCell67.Padding = new DevExpress.XtraPrinting.PaddingInfo(0, 30, 0, 0, 100F);
            this.xrTableCell67.StylePriority.UseBackColor = false;
            this.xrTableCell67.StylePriority.UseBorderColor = false;
            this.xrTableCell67.StylePriority.UseBorders = false;
            this.xrTableCell67.StylePriority.UseBorderWidth = false;
            this.xrTableCell67.StylePriority.UseFont = false;
            this.xrTableCell67.StylePriority.UsePadding = false;
            this.xrTableCell67.StylePriority.UseTextAlignment = false;
            this.xrTableCell67.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleRight;
            this.xrTableCell67.TextFormatString = "{0:n0}원";
            this.xrTableCell67.Weight = 1.7509129190934805D;
            // 
            // GroupHeader1
            // 
            this.GroupHeader1.Controls.AddRange(new DevExpress.XtraReports.UI.XRControl[] {
            this.headerTable});
            this.GroupHeader1.HeightF = 37F;
            this.GroupHeader1.Name = "GroupHeader1";
            this.GroupHeader1.RepeatEveryPage = true;
            this.GroupHeader1.StyleName = "baseControlStyle";
            // 
            // headerTable
            // 
            this.headerTable.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(74)))), ((int)(((byte)(183)))), ((int)(((byte)(222)))));
            this.headerTable.Borders = ((DevExpress.XtraPrinting.BorderSide)((((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Top) 
            | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.headerTable.Font = new System.Drawing.Font("Segoe UI", 9.75F, System.Drawing.FontStyle.Bold);
            this.headerTable.ForeColor = System.Drawing.Color.White;
            this.headerTable.LocationFloat = new DevExpress.Utils.PointFloat(6.00001F, 0F);
            this.headerTable.Name = "headerTable";
            this.headerTable.Rows.AddRange(new DevExpress.XtraReports.UI.XRTableRow[] {
            this.headerTableRow});
            this.headerTable.SizeF = new System.Drawing.SizeF(730.9999F, 37F);
            this.headerTable.StylePriority.UseBackColor = false;
            this.headerTable.StylePriority.UseBorders = false;
            this.headerTable.StylePriority.UseFont = false;
            this.headerTable.StylePriority.UseForeColor = false;
            this.headerTable.StylePriority.UsePadding = false;
            // 
            // headerTableRow
            // 
            this.headerTableRow.Cells.AddRange(new DevExpress.XtraReports.UI.XRTableCell[] {
            this.productDesctiptionCaption,
            this.quantityCaption,
            this.unitPriceCaption,
            this.lineTotalCaption,
            this.xrTableCell1,
            this.xrTableCell3});
            this.headerTableRow.Name = "headerTableRow";
            this.headerTableRow.Weight = 8.42360394673376D;
            // 
            // productDesctiptionCaption
            // 
            this.productDesctiptionCaption.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(229)))), ((int)(((byte)(224)))), ((int)(((byte)(220)))));
            this.productDesctiptionCaption.BorderColor = System.Drawing.Color.Black;
            this.productDesctiptionCaption.Borders = ((DevExpress.XtraPrinting.BorderSide)((((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Top) 
            | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.productDesctiptionCaption.BorderWidth = 1F;
            this.productDesctiptionCaption.Font = new System.Drawing.Font("맑은 고딕", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.productDesctiptionCaption.ForeColor = System.Drawing.Color.Black;
            this.productDesctiptionCaption.Name = "productDesctiptionCaption";
            this.productDesctiptionCaption.Padding = new DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 100F);
            this.productDesctiptionCaption.StylePriority.UseBackColor = false;
            this.productDesctiptionCaption.StylePriority.UseBorderColor = false;
            this.productDesctiptionCaption.StylePriority.UseBorders = false;
            this.productDesctiptionCaption.StylePriority.UseBorderWidth = false;
            this.productDesctiptionCaption.StylePriority.UseFont = false;
            this.productDesctiptionCaption.StylePriority.UseForeColor = false;
            this.productDesctiptionCaption.StylePriority.UsePadding = false;
            this.productDesctiptionCaption.StylePriority.UseTextAlignment = false;
            this.productDesctiptionCaption.Text = "No.";
            this.productDesctiptionCaption.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            this.productDesctiptionCaption.Weight = 0.0937956240630575D;
            // 
            // quantityCaption
            // 
            this.quantityCaption.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(229)))), ((int)(((byte)(224)))), ((int)(((byte)(220)))));
            this.quantityCaption.BorderColor = System.Drawing.Color.Black;
            this.quantityCaption.Borders = ((DevExpress.XtraPrinting.BorderSide)((((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Top) 
            | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.quantityCaption.BorderWidth = 1F;
            this.quantityCaption.Font = new System.Drawing.Font("맑은 고딕", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.quantityCaption.ForeColor = System.Drawing.Color.Black;
            this.quantityCaption.Name = "quantityCaption";
            this.quantityCaption.StylePriority.UseBackColor = false;
            this.quantityCaption.StylePriority.UseBorderColor = false;
            this.quantityCaption.StylePriority.UseBorders = false;
            this.quantityCaption.StylePriority.UseBorderWidth = false;
            this.quantityCaption.StylePriority.UseFont = false;
            this.quantityCaption.StylePriority.UseForeColor = false;
            this.quantityCaption.StylePriority.UseTextAlignment = false;
            this.quantityCaption.Text = "상품코드";
            this.quantityCaption.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            this.quantityCaption.Weight = 0.26193929414210243D;
            // 
            // unitPriceCaption
            // 
            this.unitPriceCaption.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(229)))), ((int)(((byte)(224)))), ((int)(((byte)(220)))));
            this.unitPriceCaption.BorderColor = System.Drawing.Color.Black;
            this.unitPriceCaption.Borders = ((DevExpress.XtraPrinting.BorderSide)((((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Top) 
            | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.unitPriceCaption.BorderWidth = 1F;
            this.unitPriceCaption.Font = new System.Drawing.Font("맑은 고딕", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.unitPriceCaption.ForeColor = System.Drawing.Color.Black;
            this.unitPriceCaption.Name = "unitPriceCaption";
            this.unitPriceCaption.StylePriority.UseBackColor = false;
            this.unitPriceCaption.StylePriority.UseBorderColor = false;
            this.unitPriceCaption.StylePriority.UseBorders = false;
            this.unitPriceCaption.StylePriority.UseBorderWidth = false;
            this.unitPriceCaption.StylePriority.UseFont = false;
            this.unitPriceCaption.StylePriority.UseForeColor = false;
            this.unitPriceCaption.StylePriority.UseTextAlignment = false;
            this.unitPriceCaption.Text = "상품정보";
            this.unitPriceCaption.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            this.unitPriceCaption.Weight = 0.73720044129072559D;
            // 
            // lineTotalCaption
            // 
            this.lineTotalCaption.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(229)))), ((int)(((byte)(224)))), ((int)(((byte)(220)))));
            this.lineTotalCaption.BorderColor = System.Drawing.Color.Black;
            this.lineTotalCaption.Borders = ((DevExpress.XtraPrinting.BorderSide)((((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Top) 
            | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.lineTotalCaption.BorderWidth = 1F;
            this.lineTotalCaption.Font = new System.Drawing.Font("맑은 고딕", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lineTotalCaption.ForeColor = System.Drawing.Color.Black;
            this.lineTotalCaption.Name = "lineTotalCaption";
            this.lineTotalCaption.StylePriority.UseBackColor = false;
            this.lineTotalCaption.StylePriority.UseBorderColor = false;
            this.lineTotalCaption.StylePriority.UseBorders = false;
            this.lineTotalCaption.StylePriority.UseBorderWidth = false;
            this.lineTotalCaption.StylePriority.UseFont = false;
            this.lineTotalCaption.StylePriority.UseForeColor = false;
            this.lineTotalCaption.StylePriority.UseTextAlignment = false;
            this.lineTotalCaption.Text = "상품가격";
            this.lineTotalCaption.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            this.lineTotalCaption.Weight = 0.2180465625212841D;
            // 
            // xrTableCell1
            // 
            this.xrTableCell1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(229)))), ((int)(((byte)(224)))), ((int)(((byte)(220)))));
            this.xrTableCell1.BorderColor = System.Drawing.Color.Black;
            this.xrTableCell1.Borders = ((DevExpress.XtraPrinting.BorderSide)((((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Top) 
            | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTableCell1.BorderWidth = 1F;
            this.xrTableCell1.Font = new System.Drawing.Font("맑은 고딕", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.xrTableCell1.ForeColor = System.Drawing.Color.Black;
            this.xrTableCell1.Name = "xrTableCell1";
            this.xrTableCell1.StylePriority.UseBackColor = false;
            this.xrTableCell1.StylePriority.UseBorderColor = false;
            this.xrTableCell1.StylePriority.UseBorders = false;
            this.xrTableCell1.StylePriority.UseBorderWidth = false;
            this.xrTableCell1.StylePriority.UseFont = false;
            this.xrTableCell1.StylePriority.UseForeColor = false;
            this.xrTableCell1.StylePriority.UseTextAlignment = false;
            this.xrTableCell1.Text = "단위수량";
            this.xrTableCell1.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            this.xrTableCell1.Weight = 0.27956891789823135D;
            // 
            // xrTableCell3
            // 
            this.xrTableCell3.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(229)))), ((int)(((byte)(224)))), ((int)(((byte)(220)))));
            this.xrTableCell3.BorderColor = System.Drawing.Color.Black;
            this.xrTableCell3.Borders = ((DevExpress.XtraPrinting.BorderSide)((((DevExpress.XtraPrinting.BorderSide.Left | DevExpress.XtraPrinting.BorderSide.Top) 
            | DevExpress.XtraPrinting.BorderSide.Right) 
            | DevExpress.XtraPrinting.BorderSide.Bottom)));
            this.xrTableCell3.BorderWidth = 1F;
            this.xrTableCell3.Font = new System.Drawing.Font("맑은 고딕", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.xrTableCell3.ForeColor = System.Drawing.Color.Black;
            this.xrTableCell3.Name = "xrTableCell3";
            this.xrTableCell3.StylePriority.UseBackColor = false;
            this.xrTableCell3.StylePriority.UseBorderColor = false;
            this.xrTableCell3.StylePriority.UseBorders = false;
            this.xrTableCell3.StylePriority.UseBorderWidth = false;
            this.xrTableCell3.StylePriority.UseFont = false;
            this.xrTableCell3.StylePriority.UseForeColor = false;
            this.xrTableCell3.StylePriority.UseTextAlignment = false;
            this.xrTableCell3.Text = "공급가액";
            this.xrTableCell3.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            this.xrTableCell3.Weight = 0.27728698836739241D;
            // 
            // sqlDataSource1
            // 
            this.sqlDataSource1.ConnectionName = "SocialDB";
            this.sqlDataSource1.Name = "sqlDataSource1";
            storedProcQuery1.Name = "print";
            queryParameter1.Name = "P_ORDERCODENO";
            queryParameter1.Type = typeof(string);
            queryParameter2.Name = "P_SVID_USER";
            queryParameter2.Type = typeof(string);
            queryParameter3.Name = "P_SALECOMPCODE";
            queryParameter3.Type = typeof(string);
            queryParameter4.Name = "P_ORDERSTATUS";
            queryParameter4.Type = typeof(decimal);
            queryParameter4.ValueInfo = "0";
            queryParameter5.Name = "CUR_VCURSOR";
            queryParameter5.Type = typeof(object);
            storedProcQuery1.Parameters.Add(queryParameter1);
            storedProcQuery1.Parameters.Add(queryParameter2);
            storedProcQuery1.Parameters.Add(queryParameter3);
            storedProcQuery1.Parameters.Add(queryParameter4);
            storedProcQuery1.Parameters.Add(queryParameter5);
            storedProcQuery1.StoredProcName = "\"PKG_PRINT\".\"PROC_PRINT_ORDERHISTORYLIST_ADMIN\"";
            this.sqlDataSource1.Queries.AddRange(new DevExpress.DataAccess.Sql.SqlQuery[] {
            storedProcQuery1});
            // 
            // baseControlStyle
            // 
            this.baseControlStyle.Font = new System.Drawing.Font("Segoe UI", 9.75F);
            this.baseControlStyle.Name = "baseControlStyle";
            this.baseControlStyle.Padding = new DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 100F);
            this.baseControlStyle.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            // 
            // ReportHeader
            // 
            this.ReportHeader.Controls.AddRange(new DevExpress.XtraReports.UI.XRControl[] {
            this.xrLabel1});
            this.ReportHeader.HeightF = 75.41668F;
            this.ReportHeader.Name = "ReportHeader";
            this.ReportHeader.StylePriority.UseTextAlignment = false;
            this.ReportHeader.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            // 
            // xrLabel1
            // 
            this.xrLabel1.Borders = DevExpress.XtraPrinting.BorderSide.None;
            this.xrLabel1.Font = new System.Drawing.Font("맑은 고딕", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.xrLabel1.LocationFloat = new DevExpress.Utils.PointFloat(204.7917F, 40F);
            this.xrLabel1.Name = "xrLabel1";
            this.xrLabel1.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 0, 100F);
            this.xrLabel1.SizeF = new System.Drawing.SizeF(328.6306F, 23F);
            this.xrLabel1.StylePriority.UseBorders = false;
            this.xrLabel1.StylePriority.UseFont = false;
            this.xrLabel1.Text = "거래명세서(공급받는자 보관용)";
            // 
            // AdminTransactionReport
            // 
            this.BackColor = System.Drawing.Color.White;
            this.Bands.AddRange(new DevExpress.XtraReports.UI.Band[] {
            this.Detail,
            this.TopMargin,
            this.BottomMargin,
            this.GroupHeader2,
            this.GroupFooter1,
            this.GroupHeader1,
            this.ReportHeader});
            this.ComponentStorage.AddRange(new System.ComponentModel.IComponent[] {
            this.sqlDataSource1});
            this.DataMember = "print";
            this.DataSource = this.sqlDataSource1;
            this.Font = new System.Drawing.Font("맑은 고딕", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.Margins = new System.Drawing.Printing.Margins(40, 40, 0, 22);
            this.Padding = new DevExpress.XtraPrinting.PaddingInfo(2, 2, 0, 2, 100F);
            this.PageHeight = 1169;
            this.PageWidth = 827;
            this.PaperKind = System.Drawing.Printing.PaperKind.A4;
            this.StyleSheet.AddRange(new DevExpress.XtraReports.UI.XRControlStyle[] {
            this.baseControlStyle});
            this.TextAlignment = DevExpress.XtraPrinting.TextAlignment.MiddleCenter;
            this.Version = "18.2";
            ((System.ComponentModel.ISupportInitialize)(this.detailTable)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.xrTable3)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.xrTable2)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.invoiceInfoTable)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.xrTable4)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.xrTable1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.headerTable)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this)).EndInit();

    }

    #endregion
}
