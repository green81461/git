<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Master/Default.master" CodeFile="DeliveryInsert.aspx.cs" Inherits="Delivery_DeliveryInsert" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  
 <%--   
    <script type="text/javascript">
        function setparentText() {
            document.getElementById("txtPostal").value = opener.document.getElementById("txtPostal").value;
            document.getElementById("txtAddress").value = opener.document.getElementById("txtAddress").value;
            document.getElementById("txtDetail").value = opener.document.getElementById("txtDetail").value;
        }
        
  </script>--%>
   
    <style>
        .DeliveryInsert {
            width: 55%;
            border: 0.5px solid darkgray;
            margin: 0 auto;
            clear: both;
        }
    </style>
    <div class="DeliveryInsert">
     <table style="text-align:'left';""  border-collapse:  collapse; text-align: center; border: 1px solid solid;" border="1">
        <tr>
            <td>사업장</td>
              <td>사업부</td>
              <td>부서명</td>
              <td>담당자</td>
              <td>우편번호</td>
              <td>주소</td>
              <td>상세주소</td>
        </tr>

         <tr>
             <td >
             <input type="text" id="a" />
             </td>
               <td >
             <input type="text" id="b" />
             </td>
               <td >
             <input type="text" id="c" />
             </td>
               <td >
             <input type="text" id="d" />
             </td>

             <td>
                   <input type="text" id="ZipCode" />
             <td>
                   <input type="text" id="Address_1" />
             <td>
                   <input type="text" id="Address_2" />
         </tr>
    </table>

        <input type="button" id="btnCancle" value="취소" onclick="window.close()" />
         <asp:Button ID="btnAdd" runat="server" Text="추가" OnClick="btnAdd_Click" />
        
       
    
    </div>
</asp:Content>

