<#assign pojoNameLower = pojo.shortName.substring(0,1).toLowerCase()+pojo.shortName.substring(1)>
<%@ include file="/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="${pojoNameLower}List.title"/></title>
    <meta name="heading" content="<fmt:message key='${pojoNameLower}List.heading'/>"/>
    <meta name="menu" content="${pojo.shortName}Menu"/>
</head>

<c:set var="buttons">
    <input type="button" style="margin-right: 5px"
        onclick="location.href='<c:url value="/${pojoNameLower}form.html"/>'"
        value="<fmt:message key="button.add"/>"/>

    <input type="button" onclick="location.href='<c:url value="/mainMenu.html"/>'"
        value="<fmt:message key="button.done"/>"/>
</c:set>

<c:out value="${'$'}{buttons}" escapeXml="false"/>

<display:table name="${pojoNameLower}List" class="table" requestURI="" id="${pojoNameLower}List" export="true" pagesize="25">
<#foreach field in pojo.getAllPropertiesIterator()>
<#if field.equals(pojo.identifierProperty)>
    <display:column property="${field.name}" sortable="true" href="${pojoNameLower}form.html" media="html"
        paramId="${field.name}" paramProperty="${field.name}" titleKey="${pojoNameLower}.${field.name}"/>
    <display:column property="${field.name}" media="csv excel xml pdf" titleKey="${pojoNameLower}.${field.name}"/>
<#elseif !c2h.isCollection(field) && !c2h.isManyToOne(field)>
    <#if field.value.typeName == "java.util.Date">
        <#lt/>    <display:column sortProperty="${field.name}" sortable="true" titleKey="${pojoNameLower}.${field.name}">
        <#lt/>         <fmt:formatDate value="${'$'}{${pojoNameLower}List.${field.name}}" pattern="${'$'}{datePattern}"/>
        <#lt/>    </display:column>
    <#elseif field.value.typeName == "boolean">
        <#lt/>    <display:column sortProperty="${field.name}" sortable="true" titleKey="${pojoNameLower}.${field.name}">
        <#lt/>        <input type="checkbox" disabled="disabled" <c:if test="${'$'}{${pojoNameLower}List.${field.name}}">checked="checked"</c:if>/>
        <#lt/>    </display:column>
    <#else>
        <#lt/>    <display:column property="${field.name}" sortable="true" titleKey="${pojoNameLower}.${field.name}"/>
    </#if>
</#if>
</#foreach>

    <display:setProperty name="paging.banner.item_name" value="${pojoNameLower}"/>
    <display:setProperty name="paging.banner.items_name" value="${pojoNameLower}s"/>

    <display:setProperty name="export.excel.filename" value="${pojo.shortName} List.xls"/>
    <display:setProperty name="export.csv.filename" value="${pojo.shortName} List.csv"/>
    <display:setProperty name="export.pdf.filename" value="${pojo.shortName} List.pdf"/>
</display:table>

<c:out value="${'$'}{buttons}" escapeXml="false"/>

<script type="text/javascript">
    highlightTableRows("${pojoNameLower}List");
</script> 