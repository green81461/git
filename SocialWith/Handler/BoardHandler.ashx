<%@ WebHandler Language="C#" Class="BoardHandler" %>

using System;
using System.Web;
using System.Collections.Generic;
using Newtonsoft.Json;
using Urian.Core;
using SocialWith.Biz.Board;

public class BoardHandler : IHttpHandler
{
    protected BoardService _boardService = new BoardService();
    

    public void ProcessRequest(HttpContext context)
    {
        string method = context.Request.Form["Method"].AsText();

        switch (method)
        {
            case "GetBoardList":
                GetBoardList(context);
                break;
            case "GetBoardView":
                GetBoardView(context);
                break;


        }
    }

    //게시판 목록 데이터 갖고오기
    protected void GetBoardList(HttpContext context)
    {

        string svidUser = context.Request.Form["SvidUser"].AsText();
        string searchTarget = context.Request.Form["SearchTarget"].AsText();
        string searchkeyword = context.Request.Form["SearchKeyword"].AsText();
        int gubun = context.Request.Form["Gubun"].AsInt(2);
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SEARCHKEYWORD", searchkeyword.Trim() },
            {"nvar_P_SERACHTARGET",searchTarget },
            {"inte_P_PAGENO", pageNo },
            {"inte_P_PAGESIZE", pageSize },
            {"inte_P_BOARD_GUBUN", gubun }, // 1:1문의 구분코드
            {"nvar_P_BOARD_USER", svidUser }
        };

        var list = _boardService.GetBoardList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }

    //게시판 뷰 데이터 갖고오기
    protected void GetBoardView(HttpContext context)
    {

        string svidBoard = context.Request.Form["SvidBoard"].AsText();
        string loginId = context.Request.Form["LoginId"].AsText();
        //여기에 해야하는건지.. 1개 출력인데.. 리스트가 아닌..

        var paramList = new Dictionary<string, object> {
           {"nvar_P_SVID_BOARD", svidBoard }

        };

        var board = _boardService.GetBoard(paramList);

        if (board != null)
        {
            if (board.Board_Write.Equals(loginId) == false)
            {
                ReadCountUpdate(svidBoard);
            }
        }

        var returnjsonData = JsonConvert.SerializeObject(board);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }

    //조회수 
    protected void ReadCountUpdate(string svid)
    {
        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_BOARD", svid },
         };
        _boardService.UpdateBoardReadCount(paramList);
    }

    //파일 다운로드 카운트 업데이트
    protected void AttachDownCountUpdate(string svid)
    {
        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_BOARD", svid },
         };
        _boardService.UpdateBoardAttachCount(paramList);
    }



   


    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}