<%@page import="java.util.*"%>
<%@page import="org.semanticwb.model.*"%>
<%@page import="org.semanticwb.portal.api.GenericSemResource"%>
<%@page import="org.semanticwb.platform.SemanticObject"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="org.semanticwb.portal.api.SWBResource"%>
<%@page import="org.semanticwb.portal.resources.sem.calendar.Calendar"%>
<%@page import="org.semanticwb.portal.resources.sem.calendar.Event"%>
<%@page import="java.text.SimpleDateFormat"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
            Resource base = paramRequest.getResourceBase();
            User user = paramRequest.getUser();
            String lang = user.getLanguage();
            String coun = user.getCountry();
            String sToday ;
            SWBResource res = SWBPortal.getResourceMgr().getResource(base);
            if (user.haveAccess((GenericObject)res)) {
                SemanticObject semObj = ((GenericSemResource) res).getSemanticObject();
                Calendar cal = (Calendar) semObj.createGenericInstance();
                Iterator<Event> itEve = cal.listEventses();
                SimpleDateFormat sdfEveIn = new SimpleDateFormat("yyyy-MM-dd");
//                SimpleDateFormat sdfEveOut = new SimpleDateFormat("dd/MMM/yy",new Locale(lang,coun));
                SimpleDateFormat sdfEveOutD = new SimpleDateFormat("dd",new Locale(lang));
                SimpleDateFormat sdfEveOutM = new SimpleDateFormat("MMM",new Locale(lang));
                SimpleDateFormat sdfEveOutY = new SimpleDateFormat("yy",new Locale(lang));
                Date dEve = new Date();
                sToday =sdfEveIn.format(dEve);
                List liEve = new ArrayList();
                while (itEve.hasNext()) {
                    Event eve = (Event)itEve.next();
                    if (eve.getEventInitDate().compareTo(sToday)>=0){
                        liEve.add(eve);
                    }
                }
                if (liEve.size() > 0) {
%><ul class="listaEventos">
<%
                     Collections.sort(liEve, new EventComparator());
                    for (int i = 0; i < liEve.size()& i<cal.getNumberNearEvents() ; i++) {
                         Event eve = (Event) liEve.get(i);
                         dEve = sdfEveIn.parse(eve.getEventInitDate());
%>
    <li>
        <div class="fechaEvento">
            <span id="diaEvento"><%=sdfEveOutD.format(dEve)%></span>
            <span id="mesEvento"><%=sdfEveOutM.format(dEve)%></span>
            <span id="aniEvento"><%=sdfEveOutY.format(dEve)%></span>
            <p><%=eve.getDisplayTitle(lang)%></p>
            <p><%=eve.getDisplayDescription(lang)%></p>
        </div>
    </li>
<%
                    }
%></ul>
<%
                }
            }
         %>
<%!
    public class EventComparator implements Comparator {

        public int compare(Object event1, Object event2) {
            int comparacion;
            String d1= ((Event) event1).getEventInitDate();
            String d2= ((Event) event2).getEventInitDate();
            comparacion=d1.compareTo(d2);
            return comparacion;
        }
    }

    %>

