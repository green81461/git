<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="NoticeView.aspx.cs" Inherits="Notice_NoticeView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

<script  type="text/javascript">
    function fnDeleteConfirm()
    {
        if (confirm('삭제하시겠습니까?')) {
            return true;
        }
        return false;
    }

    function fnGoEdit() {
        var svid = '<%= Svid%>';
        location.href = 'NoticeEdit.aspx?Svid=' + svid;
        return false;
    }

    function fnGoList() {
        location.href = 'NoticeList.aspx';
        return false;
    }
</script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <!--공지사항 게시판 시작-->
    <div class="sub-contents-div">

         <div class="sub-title-div">
	        <img src="/images/NoticeList_go_nam.png" />
	        <%--<p class="p-title-mainsentence">
                       공지사항
                       <span class="span-title-subsentence">편리한 쇼핑을 위한 최근 소식이나 유익한 정보를 고객님께 안내해 드리고 있습니다.</span>
            </p>--%>
         </div>
        <div class="board-view-div">
            <table class="tbl_main">
                <tr>
                   <th class="border-right">
                      <asp:Label runat="server" ID="lblTitleHeader" Text="제목"></asp:Label>
                    </th>
                    <td colspan="3">
                        <asp:Label runat="server" ID="lblTitle"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <th class="border-right">
                        <asp:Label runat="server" ID="lblWriteHeader" Text="작성자  "></asp:Label>
                    </th>
                    <td class="border-right">
                        <asp:Label runat="server" ID="lblWriter"></asp:Label>
                    </td>
                    <th class="border-right">
                        <asp:Label runat="server" ID="lblRegDateHeader" Text="작성일  "></asp:Label>
                    </th>
                    <td>
                        <asp:Label runat="server" ID="lblRegDate"></asp:Label>
                    </td>
                </tr>
                 <tr>
                    <td class="padding-left-ten txt-contents-td align-left" colspan="4">
                        <asp:Label runat="server" ID="lblContent"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <th class="border-right">
                        <asp:Label runat="server" ID="lblFileHeader" Text="첨부파일"></asp:Label>
                    </th>
                    <td class="padding-left-ten" colspan="3">
                         <asp:LinkButton runat="server" ID="lbFileDown" OnClick="lbFileDown_Click"></asp:LinkButton>
                         <asp:HiddenField runat ="server" ID="hfFilePath" />
                         <asp:HiddenField runat ="server" ID="hfFileName" />
                    </td>
                </tr>
            </table>
        </div>
        <div class="btn-notice-view-bottom-div">
            <asp:Button ID="btnSearch" runat="server" OnClientClick="return fnGoList();"  Text="목록" CssClass="mainbtn type1" Width="95" Height="30"/>
        </div>
        <div class="left-menu-wrap" id="divLeftMenu">
	        <dl>
		        <dt>
			        <strong>고객센터</strong>
		        </dt>
		        <dd class="active">
		           <a href="/Notice/NoticeList.aspx">공지사항</a> 
		        </dd>
		        <dd>
		           <a href="/Board/BoardList.aspx">질문게시판</a> 
		        </dd>
		        <dd>
		           <a href="/Other/Faq.aspx">FAQ</a> 
		        </dd>
		        <%--<dd>
		           <a>담당자 전화번호</a> 
		        </dd>--%>
		    </dl>
        </div>
    </div>
    <!--공지사항 게시판 끝-->
</asp:Content>

