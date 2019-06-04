<%@ WebHandler Language="C#" Class="CartHandler" %>

using System;
using System.Web;
using SocialWith.Biz.Cart;
using System.Collections.Generic;
using Urian.Core;
using Newtonsoft.Json;

public class CartHandler : IHttpHandler {

    CartService cartService = new CartService();

    public void ProcessRequest (HttpContext context) {

        //string qty = context.Request.Form["Qty"];
        string flag = context.Request.Form["Flag"];

        switch (flag.AsText())
        {
            case "Add":
                SaveCart(context);
                break;
            case "MultiAdd":
                MultiSaveCart(context);
                break;
            case "QuickMultiAdd":
                QuickMultiSaveCart(context);
                break;
            case "QTY":
                UpdateCart(context);
                break;
            case "MultiUpdateCart":
                MultiUpdateCart(context);
                break;
            case "DEL":
                DeleteCart(context);
                break;
            case "Budget":
                GetBudget(context);
                break;
            case "RemoveRepetition":
                RemoveRepetition(context);
                break;
            case "MultiSaveCartByWishList":
                MultiSaveCartByWishList(context);
                break;
        }

    }
    
    // 장바구니 중복제거
    protected void RemoveRepetition(HttpContext context)
    {
   
        string svid_user = context.Request.Form["SvidUser"].AsText();
    
        var paramList = new Dictionary<string, object>() {  
            {"nvar_P_SVID_USER", svid_user}
            
        };

        cartService.RemoveRepetitionCart(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write("{\"Result\": \"OK\"}");
    }


    // 장바구니에 저장
    protected void SaveCart(HttpContext context)
    {
        string cartCode = context.Request.Form["CartCode"].AsText();
        string goodsFinalCategoryCode = context.Request.Form["GoodsFinCtgrCode"].AsText();
        string goodsGroupCode = context.Request.Form["GoodsGrpCode"].AsText();
        string goodsCode = context.Request.Form["GoodsCode"].AsText();
        string qty = context.Request.Form["QTY"].AsText();
        string memo = context.Request.Form["Memo"].AsText();
        string svid_user = context.Request.Form["SvidUser"].AsText();

        //////////////  테스트용으로 임시값 지정함..... 나중에 수정해야 함 //////////////////
        cartCode = NextCartCode();
        //goodsFinalCategoryCode = "070101";
        //goodsGroupCode = "00456";
        //goodsCode = "2800051";
        //qty = "3";
        //memo = "메모메모";

        var paramList = new Dictionary<string, object>() {
             {"nvar_P_CARTCODE", cartCode}
            ,{"nvar_P_GOODSFINALCATEGORYCODE", goodsFinalCategoryCode}
            ,{"nvar_P_GOODSGROUPCODE", goodsGroupCode}
            ,{"nvar_P_GOODSCODE", goodsCode}
            ,{"nvar_P_GOODSRECOMMCODE", ""}
            ,{"nvar_P_SVID_USER", svid_user}
            ,{"nume_P_QTY", Convert.ToInt32(qty)}
            ,{"nvar_P_MEMO", memo}
        };

        cartService.SaveCart(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write("{\"Result\": \"OK\"}");
    }


    protected void MultiSaveCart(HttpContext context)
    {
        string goodsFinalCategoryCode = context.Request.Form["GoodsFinCtgrCode"].AsText();
        string goodsGroupCode = context.Request.Form["GoodsGrpCode"].AsText();
        string svid_user = context.Request.Form["SvidUser"].AsText();
        string goodsCodes = context.Request.Form["GoodsCodes"].AsText();
        string qtys = context.Request.Form["QTYs"].AsText();

        var goodsCodeArray = goodsCodes.Split('/');
        var qtysArray = qtys.Split('/');

        var cartCode = NextCartCode();
        for (int i = 1; i <= goodsCodeArray.Length; i++)
        {

            var goodsCode = goodsCodeArray[i - 1];
            var qty = qtysArray[i - 1];
            var paramList = new Dictionary<string, object>() {
             {"nvar_P_CARTCODE", cartCode}
            ,{"nvar_P_GOODSFINALCATEGORYCODE", goodsFinalCategoryCode}
            ,{"nvar_P_GOODSGROUPCODE", goodsGroupCode}
            ,{"nvar_P_GOODSCODE", goodsCode}
             ,{"nvar_P_GOODSRECOMMCODE", ""}
            ,{"nvar_P_SVID_USER", svid_user}
            ,{"nume_P_QTY", Convert.ToInt32(qty)}
            ,{"nvar_P_MEMO", ""}
        };

            cartService.SaveCart(paramList);
        }


        context.Response.ContentType = "text/plain";
        context.Response.Write("{\"Result\": \"OK\"}");
    }
    
    protected void MultiSaveCartByWishList(HttpContext context)
    {
        string goodsFinalCategoryCode = context.Request.Form["GoodsFinCtgrCodes"].AsText();
        string goodsGroupCode = context.Request.Form["GoodsGrpCodes"].AsText();
        string svid_user = context.Request.Form["SvidUser"].AsText();
        string goodsCodes = context.Request.Form["GoodsCodes"].AsText();
        string qtys = context.Request.Form["Qtys"].AsText();
        string recommCode = context.Request.Form["RecommCode"].AsText();
        var goodsCodeArray = goodsCodes.Split('/');
        var groupCodeArray = goodsGroupCode.Split('/');
        var categoryCodeArray = goodsFinalCategoryCode.Split('/');
        var qtyArray = qtys.Split('/');
        var cartCode = NextCartCode();
        for (int i = 1; i <= goodsCodeArray.Length; i++)
        {

            var goodsCode = goodsCodeArray[i - 1];
            var groupCode = groupCodeArray[i - 1];
            var categoryCode = categoryCodeArray[i - 1];
            var qty = qtyArray[i - 1];
            var paramList = new Dictionary<string, object>() {
             {"nvar_P_CARTCODE", cartCode}
            ,{"nvar_P_GOODSFINALCATEGORYCODE", categoryCode}
            ,{"nvar_P_GOODSGROUPCODE", groupCode}
            ,{"nvar_P_GOODSCODE", goodsCode}
            ,{"nvar_P_GOODSRECOMMCODE", recommCode}
            ,{"nvar_P_SVID_USER", svid_user}
            ,{"nume_P_QTY",qty}
            ,{"nvar_P_MEMO", ""}
        };

            cartService.SaveCart(paramList);
        }


        context.Response.ContentType = "text/plain";
        context.Response.Write("{\"Result\": \"OK\"}");
    }
    // cartCode 값 생성
    protected string NextCartCode()
    {
        string nextSeq = cartService.GetLastCartCode();
        string nowDate = DateTime.Now.ToString("yyMMdd");

        string nextCode = "CN-" + nowDate + "-" + nextSeq;

        //if (!string.IsNullOrWhiteSpace(lastCode))
        //{
        //    nextCode = StringValue.NextCartCode(lastCode.AsText());
        //} else
        //{
        //    nextCode = "CN" + nowDate + "00001";
        //}

        return nextCode;
    }

    // 수량값 변경
    public void UpdateCart(HttpContext context)
    {
        int num_cartNo = context.Request.Form["Unum_CartNo"].AsInt();
        string cartCode = context.Request.Form["CartCode"];
        string goodsFinalCategoryCode = context.Request.Form["GoodsFinalCategoryCode"];
        string goodsGroupCode = context.Request.Form["GoodsGroupCode"];
        string goodsCode = context.Request.Form["GoodsCode"];
        string svidUser = context.Request.Form["SvidUser"];
        int qty = context.Request.Form["Qty"].AsInt();
        string budgetAccount = context.Request.Form["BudgetAccount"];
        string delFlag = ""; //나중에 이거 수정해야...맞는 값 넣어줘야 함.
        string flag = "QTY";

        var paramList = new Dictionary<string, object> {
            {"nume_P_UNUM_CARTNO", num_cartNo},
            {"nvar_P_CARTCODE", cartCode},
            {"nvar_P_GOODSFINALCATEGORYCODE", goodsFinalCategoryCode},
            {"nvar_P_GOODSGROUPCODE", goodsGroupCode},
            {"nvar_P_GOODSCODE", goodsCode},
            {"nvar_P_SVID_USER", svidUser},
            {"nvar_P_QTY", qty},
            {"nvar_P_DELFLAG", delFlag},
            {"nvar_P_BUDGETACCOUNT", budgetAccount},
            {"nvar_P_ORDERREQUESTSTATUS", ""},
            {"nvar_P_ORDERDOCUMENTSTATUS", ""},
            {"nvar_P_FLAG", flag},
        };

        cartService.UpdateCart(paramList);
        context.Response.ContentType = "text/json";
        context.Response.Write("{\"Result\": \"OK\"}");
    }

    //장바구니 삭제
    public void DeleteCart(HttpContext context)
    {
        int num_cartNo = context.Request.Form["Unum_CartNo"].AsInt();
        string cartCode = context.Request.Form["CartCode"];

        string goodsFinalCategoryCode = context.Request.Form["GoodsFinalCategoryCode"];
        string goodsGroupCode = context.Request.Form["GoodsGroupCode"];
        string goodsCode = context.Request.Form["GoodsCode"];
        string svidUser = context.Request.Form["SvidUser"];
        int qty = 0; //그냥 아무거나 넣어줬음
        string delFlag = "Y"; //나중에 이거 수정해야...맞는 값 넣어줘야 함.
        string flag = "DEL";

        var paramList = new Dictionary<string, object> {
            {"nume_P_UNUM_CARTNO", num_cartNo},
            {"nvar_P_CARTCODE", cartCode},
            {"nvar_P_GOODSFINALCATEGORYCODE", goodsFinalCategoryCode},
            {"nvar_P_GOODSGROUPCODE", goodsGroupCode},
            {"nvar_P_GOODSCODE", goodsCode},
            {"nvar_P_SVID_USER", svidUser},
            {"nvar_P_QTY", qty},
            {"nvar_P_DELFLAG", delFlag},
            {"nvar_P_BUDGETACCOUNT", ""},
            {"nvar_P_ORDERREQUESTSTATUS", ""},
            {"nvar_P_ORDERDOCUMENTSTATUS", ""},
            {"nvar_P_FLAG", flag},
        };

        cartService.DeleteCart(paramList);
        context.Response.ContentType = "text/plain";
        context.Response.Write("{\"Result\": \"OK\"}");
    }

    // 간편주문에서 장바구니 담기
    protected void QuickMultiSaveCart(HttpContext context)
    {
        string goodsFinalCategoryCodes = context.Request.Form["GoodsFinCtgrCodes"].AsText();
        string goodsGroupCodes = context.Request.Form["GoodsGrpCodes"].AsText();
        string svid_user = context.Request.Form["SvidUser"].AsText();
        string goodsCodes = context.Request.Form["GoodsCodes"].AsText();
        string qtys = context.Request.Form["QTYs"].AsText();

        var goodsFinalCategoryCodeArray = goodsFinalCategoryCodes.Split('/');
        var goodsGroupCodeArray = goodsGroupCodes.Split('/');
        var goodsCodeArray = goodsCodes.Split('/');
        var qtysArray = qtys.Split('/');

        var cartCode = NextCartCode();
        for (int i = 1; i <= goodsCodeArray.Length; i++)
        {

            var goodsFinCtgrCode = goodsFinalCategoryCodeArray[i - 1];
            var goodsGrpCode = goodsGroupCodeArray[i - 1];

            var goodsCode = goodsCodeArray[i - 1];
            var qty = qtysArray[i - 1];
            var paramList = new Dictionary<string, object>() {
                 {"nvar_P_CARTCODE", cartCode}
                ,{"nvar_P_GOODSFINALCATEGORYCODE", goodsFinCtgrCode}
                ,{"nvar_P_GOODSGROUPCODE", goodsGrpCode}
                ,{"nvar_P_GOODSCODE", goodsCode}
                ,{"nvar_P_GOODSRECOMMCODE", ""}
                ,{"nvar_P_SVID_USER", svid_user}
                ,{"nume_P_QTY", Convert.ToInt32(qty)}
                ,{"nvar_P_MEMO", ""}
            };

            cartService.SaveCart(paramList);
        }


        context.Response.ContentType = "text/plain";
        context.Response.Write("{\"Result\": \"OK\"}");
    }

    //총 구매금액 계산(업데이트)
    protected void MultiUpdateCart(HttpContext context)
    {
        string num_cartNo = context.Request.Form["Unum_CartNo"].AsText();
        string cartCode = context.Request.Form["CartCode"].AsText();
        string goodsFinalCategoryCode = context.Request.Form["GoodsFinalCategoryCode"].AsText();
        string goodsGroupCode = context.Request.Form["GoodsGroupCode"].AsText();
        string goodsCode = context.Request.Form["GoodsCode"].AsText();
        string svidUser = context.Request.Form["SvidUser"].AsText();
        string qty = context.Request.Form["Qty"].AsText();
        string budgetAccount = context.Request.Form["BudgetAccount"];
        string delFlag = ""; //나중에 이거 수정해야...맞는 값 넣어줘야 함.
        string flag = "QTY";

        var cartCodeArray = cartCode.Split('/');
        var goodsFinalCategoryCodeArray = goodsFinalCategoryCode.Split('/');
        var goodsGroupCodeArray = goodsGroupCode.Split('/');
        var goodsCodeArray = goodsCode.Split('/');    
        var num_cartNoArray =  num_cartNo.Split('/'); //int형으로 바꿔줘야됨 이거 어떠케..ㅠ
        var qtyArray =  qty.Split('/');//int형으로 바꿔줘야됨 이거 어떠케..ㅠ
   

        for (int i = 0; i < cartCodeArray.Length-1; i++)
        {
            var _num_cartNo = num_cartNoArray[i];
            var _cartCode = cartCodeArray[i];
            var _goodsFinalCategoryCode = goodsFinalCategoryCodeArray[i];
            var _goodsGroupCode = goodsGroupCodeArray[i];
            var _goodsCode = goodsCodeArray[i];
            var _qty = qtyArray[i];
  

            var paramList = new Dictionary<string, object> {
                {"nume_P_UNUM_CARTNO", _num_cartNo},
                {"nvar_P_CARTCODE", _cartCode},
                {"nvar_P_GOODSFINALCATEGORYCODE", _goodsFinalCategoryCode},
                {"nvar_P_GOODSGROUPCODE", _goodsGroupCode},
                {"nvar_P_GOODSCODE", _goodsCode},
                {"nvar_P_SVID_USER", svidUser},
                {"nvar_P_QTY", _qty},
                {"nvar_P_DELFLAG", delFlag},
                {"nvar_P_BUDGETACCOUNT", ""},
                {"nvar_P_ORDERREQUESTSTATUS", ""},
                {"nvar_P_ORDERDOCUMENTSTATUS", ""},
                {"nvar_P_FLAG", flag},
            };
            cartService.UpdateCart(paramList);
        }

        context.Response.ContentType = "text/plain";
        context.Response.Write("{\"Result\": \"OK\"}");
    }

    //잔여예산
    protected void GetBudget(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"];
        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", svidUser},
        };

        var budget = cartService.GetBudget(paramList);

        var data = JsonConvert.SerializeObject(budget);
         
        context.Response.ContentType = "text/plain";
        context.Response.Write(data);
    }

    public bool IsReusable {
        get {
            return false;
        }
    }
}