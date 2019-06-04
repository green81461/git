﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Login.master" AutoEventWireup="true" CodeFile="MemberJoinSelect.aspx.cs" Inherits="Member_MemberJoinSelect" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <!-- CSS -->
   <%-- <link rel="stylesheet" type="text/css" href="../Content/membershipForm1.css" />--%>

    
    <style>
        .border-table1 {
    width: 900px;
    height: 500px;
    margin:0 auto;
    border: 1px solid #a2a2a2;
    overflow:auto;
   
   
}
        .bottom-div {
    height:23px;
}

        .inquire-div {
    width: 950px;
    height: 55px;
    background-color: #69686d;
    border: 1px solid #a2a2a2;
    margin:0 auto;
    text-align: center;
    line-height: 55px;
    color: white;
}

        .company-img {
    padding-left:20px;
    margin-left:7px;
    margin-right:20px;
    width: 264px;
    height:190px;
    
}
        .public-img {
    padding-left:20px;
    width: 264px;
    height:190px;
}
        p {
    line-height: 1;
}
    </style>



</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">   

        $(document).ready(function () {
            $('#spanCustTelNo').text($('#hdMasterCustTelNo').val());
        });
          
    </script>
    <body onselectstart="return false">
    <div class="sub-contents-div">
        
        <div class="sub-title-div" ></div>

        <asp:Label ID="joinType" runat="server" Text="Label" Visible="False"></asp:Label>

        <table class="border-table1" >
         
       
            <tr>
                <td style="padding-left:10px;"><img class="public-img" src="../images/memberjoin1.jpg" alt="공무원/공공기관" />
           
             <td>
           
                    <div style="height:150px;">
                    <p style="font-weight:bold; color:#ec2028"  >공공기관은?</p>
                    <p>- 국가기관: 중앙부처 및 그 소속기관</p>
                    <p>- 교육청: 시­·도 교육청, 지역교육청 및 학교</p>
                    <p>- 특별법에 따라 설립된 법인 중 대통령령으로 정하는 기관</p>
                    <p>&nbsp;&nbsp;중소기업중앙회, 농업협동중앙회, 수산업협동조합중앙회,산림조합중앙회,한국은행,대한상공회의소</p>  
                    <p>- [공공기관의 운영에 관한법률] 제5조에 따른 공기업 및 준 정부기관, 기타공공기관</p>    
         
                    </div>
                   
                 <div class="public">
                    <a href="Agreement.aspx?JoinType=B"><img class="join1-img" src="../images/join1_out.jpg" alt="가입하기" /></a>
                 <span style="font-weight:bold;">&nbsp;&nbsp;* 가입하기</span>를 누르시면 회원가입이 진행됩니다. </div>
                </td>
            </tr>
               
           <tr>  
                <td><img class="company-img" src="../images/memberjoin2.jpg" alt="사회적 경제기업" /></td>
          
               
                               
                <td>
                     <div style="height:150px;">
                    <p style="font-weight:bold; color:#ec2028" >사회적 경제기업은?</p>
                    <p>- 사회적 협동조합</p>
                    <p>- 사회적기업</p>
                    <p>- 장애인기업</p>
                    <p>- 여성기업</p>  
                    <p>- 기타사회단체</p>    
         
                    </div>
                    <div class="priority-company">
                     <a href="Agreement.aspx?JoinType=A"><img class="join2-img" src="../images/join1_out.jpg" alt="가입하기" /></a>
                      <span style="font-weight:bold;">&nbsp;&nbsp;* 가입하기</span>를 누르시면 회원가입이 진행됩니다.
                    </div>
                        </td>
            </tr>
          
            
        </table>
         <div class="bottom-div"></div>
         <div class="inquire-div">문의사항은 고객센터(<span id="spanCustTelNo"></span>)로 문의하시기 바랍니다.</div>    
    </div>

    
    <script type="text/javascript">
        $(function () {

            $(".priority-company>a").on("mouseover focus", function () {
               $("img", this).attr("src", $("img", this).attr("src").replace("out.jpg", "over.jpg"));
              });

        
            $(".public>a").on("mouseover focus", function () {
                $("img", this).attr("src", $("img", this).attr("src").replace("out.jpg", "over.jpg"));
            });


            $(".public").on("mouseleave", function () {
                $("img", this).attr("src", $("img", this).attr("src").replace("over.jpg", "out.jpg"));
            });

            $(".priority-company").on("mouseleave", function () {
                $("img", this).attr("src", $("img", this).attr("src").replace("over.jpg", "out.jpg"));

                     
            });
        });


      





    </script>
        </body>
</asp:Content>
