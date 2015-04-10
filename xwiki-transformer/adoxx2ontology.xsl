<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text"/>
	<xsl:template match="/">
<xsl:text># baseURI: http://learnpad.eu/transfer
# imports: http://learnpad.eu

@prefix bmm: &lt;http://ikm-group.ch/archiMEO/BMM#&gt; .
@prefix bpmn: &lt;http://ikm-group.ch/archiMEO/BPMN#&gt; .
@prefix dkm: &lt;http://ikm-group.ch/archiMEO/dkm#&gt; .
@prefix emo: &lt;http://ikm-group.ch/archiMEO/emo#&gt; .
@prefix lpd: &lt;http://learnpad.eu#&gt; .
@prefix owl: &lt;http://www.w3.org/2002/07/owl#&gt; .
@prefix rdf: &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#&gt; .
@prefix rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt; .
@prefix transfer: &lt;http://learnpad.eu/transfer#&gt; .
@prefix xsd: &lt;http://www.w3.org/2001/XMLSchema#&gt; .

&lt;http://learnpad.eu/transfer&gt;
  rdf:type owl:Ontology ;
  owl:imports &lt;http://learnpad.eu&gt; ;
  owl:versionInfo "1.0"^^xsd:string ;
.	
</xsl:text>
		<xsl:apply-templates select="//MODEL[@modeltype='Business process diagram (BPMN 2.0)']" mode="BPMN"/>
		<xsl:apply-templates select="//MODEL[@modeltype='BMM']" mode="BMM"/>
		<xsl:apply-templates select="//MODEL[@modeltype='Document and Knowledge model']" mode="DKM"/>
		<xsl:apply-templates select="//MODEL[@modeltype='Organizational structure']" mode="OMM"/>
	</xsl:template>
	
<!--
___________________________________________________________________________________________________
 Common templates
___________________________________________________________________________________________________-->
	<xsl:template name="addInModelConnection">
		<xsl:param name="objectProperty" />
		<xsl:param name="targetInstanceClass" />
		<xsl:variable name="fromInstanceName" select="@name" />
		<xsl:variable name="fromInstanceClass" select="@class" />
		  <xsl:for-each select="..//CONNECTOR/FROM[@instance=$fromInstanceName and @class=$fromInstanceClass]">
		  	<xsl:variable name="toInstance" select="../TO/@instance"/>
		  	<xsl:variable name="toId" select="//INSTANCE[@name=$toInstance and @class=$targetInstanceClass]/@id"/>
		 	<xsl:if test="$toId"> <xsl:value-of select="$objectProperty"/> transfer:<xsl:value-of select="$toId"/> ;<xsl:text>&#10;</xsl:text>
		 	</xsl:if>
		  </xsl:for-each>
	</xsl:template>	

<!--
___________________________________________________________________________________________________
 Business process diagram (BPMN 2.0)
___________________________________________________________________________________________________-->
	<xsl:template match="MODEL" mode="BPMN">
transfer:<xsl:value-of select="@id"/>
  rdf:type emo:BPMN_MetaModel ;
  rdfs:label "<xsl:value-of select="@name"/>"^^xsd:string ;
  emo:objectTypeHasID "<xsl:value-of select="@id"/>"^^xsd:string ;
  emo:objectTypeHasName "<xsl:value-of select="@name"/>"^^xsd:string ;
  emo:objectTypeHasDescription "<xsl:value-of select="@modeltype"/>"^^xsd:string ;
.	
		<xsl:variable name="modelId" select="@id">
  </xsl:variable>
		<xsl:apply-templates select=".//INSTANCE[@class='Start Event']" mode="StartEvent"/>
		<xsl:apply-templates select=".//INSTANCE[@class='End Event']" mode="EndEvent"/>
		<xsl:apply-templates select=".//INSTANCE[@class='Task']" mode="Task"/>
		<xsl:apply-templates select=".//INSTANCE[@class='Exclusive Gateway']" mode="ExclusiveGateway"/>
		<xsl:apply-templates select=".//INSTANCE[@class='Pool']" mode="Pool"/>
		<xsl:apply-templates select=".//INSTANCE[@class='Lane']" mode="Lane"/>
		<xsl:apply-templates select=".//INSTANCE[@class='Data Object'][./ATTRIBUTE[@name='Data type']='Data Input']" mode="DataInput"/>
		<xsl:apply-templates select=".//INSTANCE[@class='Data Object'][./ATTRIBUTE[@name='Data type']='Data Output']" mode="DataOutput"/>
	</xsl:template>
<!--...............................................................................................-->	

<!--
___________________________________________________________________________________________________
 Start Event
___________________________________________________________________________________________________-->
	<xsl:template match="INSTANCE" mode="StartEvent">
transfer:<xsl:value-of select="@id"/>
  rdf:type bpmn:StartEvent ;
  rdfs:label "<xsl:value-of select="@name"/>"^^xsd:string ;
  emo:objectTypeHasName "<xsl:value-of select="@class"/>"^^xsd:string ;
  lpd:bpmnStartEventHasId "<xsl:value-of select="@id"/>"^^xsd:string ;
  lpd:bpmnStartEventHasName "<xsl:value-of select="@name"/>"^^xsd:string ;
.	
	</xsl:template>
<!--...............................................................................................-->	
<!--
___________________________________________________________________________________________________
 End Event
___________________________________________________________________________________________________-->
	<xsl:template match="INSTANCE" mode="EndEvent">
transfer:<xsl:value-of select="@id"/>
  rdf:type bpmn:EndEvent ;
  rdfs:label "<xsl:value-of select="@name"/>"^^xsd:string ;
  emo:objectTypeHasName "<xsl:value-of select="@class"/>"^^xsd:string ;
  lpd:bpmnEndEventHasId "<xsl:value-of select="@id"/>"^^xsd:string ;
  lpd:bpmnEndEventHasName "<xsl:value-of select="@name"/>"^^xsd:string ;
.	
	</xsl:template>
<!--...............................................................................................-->
<!--
___________________________________________________________________________________________________
 Task
___________________________________________________________________________________________________-->
	<xsl:template match="INSTANCE" mode="Task">
transfer:<xsl:value-of select="@id"/>
  rdf:type bpmn:Task ;
  rdfs:label "<xsl:value-of select="@name"/>"^^xsd:string ;
  emo:objectTypeHasName "<xsl:value-of select="@class"/>"^^xsd:string ;
  <xsl:call-template name="addInModelConnection">
        <xsl:with-param name="objectProperty" select="'bpmn:activitiyHasReferenceToActivity'"/>
        <xsl:with-param name="targetInstanceClass" select="'Task'"/>
    </xsl:call-template>.
	</xsl:template>
<!--...............................................................................................-->
<!--
___________________________________________________________________________________________________
 Gateway
___________________________________________________________________________________________________-->
	<xsl:template match="INSTANCE" mode="ExclusiveGateway">
transfer:<xsl:value-of select="@id"/>
  rdf:type bpmn:ExclusiveGateway ;
  rdfs:label "<xsl:value-of select="@name"/>"^^xsd:string ;
  emo:objectTypeHasName "<xsl:value-of select="@class"/>"^^xsd:string ;
.	
	</xsl:template>
<!--...............................................................................................-->
<!--
___________________________________________________________________________________________________
 Data Input
___________________________________________________________________________________________________-->
	<xsl:template match="INSTANCE" mode="DataInput">
transfer:<xsl:value-of select="@id"/>
  rdf:type bpmn:DataInput ;
  rdfs:label "<xsl:value-of select="@name"/>"^^xsd:string ;
  emo:objectTypeHasName "<xsl:value-of select="@class"/>"^^xsd:string ; <xsl:apply-templates select="./INTERREF/IREF[@type='objectreference'][@tmodeltype='Document and Knowledge model']" mode="dataInputReferencesDocument"/> 
.	
	</xsl:template>
	<xsl:template match="IREF" mode="dataInputReferencesDocument">
   emo:dataInputReferencesDocument transfer:<xsl:value-of select="//MODEL[@modeltype=current()/@tmodeltype]/INSTANCE[@class=current()/@tclassname][@name=current()/@tobjname]/@id"/>		
	</xsl:template>
<!--...............................................................................................-->
<!--...............................................................................................-->
<!--
___________________________________________________________________________________________________
 Data Output
___________________________________________________________________________________________________-->
	<xsl:template match="INSTANCE" mode="DataOutput">
transfer:<xsl:value-of select="@id"/>
  rdf:type bpmn:DataOutput ;
  rdfs:label "<xsl:value-of select="@name"/>"^^xsd:string ;
  emo:objectTypeHasName "<xsl:value-of select="@class"/>"^^xsd:string ; <xsl:apply-templates select="./INTERREF/IREF[@type='objectreference'][@tmodeltype='Document and Knowledge model']" mode="dataOutputReferencesDocument"/> 
.	
	</xsl:template>
	<xsl:template match="IREF" mode="dataOutputReferencesDocument">
   emo:dataOutputReferencesDocument transfer:<xsl:value-of select="//MODEL[@modeltype=current()/@tmodeltype]/INSTANCE[@class=current()/@tclassname][@name=current()/@tobjname]/@id"/>		
	</xsl:template>
<!--...............................................................................................-->

<!--
___________________________________________________________________________________________________
 Pool
___________________________________________________________________________________________________-->
	<xsl:template match="INSTANCE" mode="Pool">
transfer:<xsl:value-of select="@id"/>
  rdf:type bpmn:Pool ;
  rdfs:label "<xsl:value-of select="@name"/>"^^xsd:string ;
  emo:objectTypeHasName "<xsl:value-of select="@class"/>"^^xsd:string ;
  lpd:bpmnPoolHasId "<xsl:value-of select="@id"/>"^^xsd:string ;
  lpd:bpmnPoolHasName "<xsl:value-of select="@name"/>"^^xsd:string ;
.	
	</xsl:template>
<!--...............................................................................................-->	

<!--
___________________________________________________________________________________________________
 Lane
___________________________________________________________________________________________________-->
	<xsl:template match="INSTANCE" mode="Lane">
transfer:<xsl:value-of select="@id"/>
  rdf:type bpmn:Lane ;
  rdfs:label "<xsl:value-of select="@name"/>"^^xsd:string ;
  emo:objectTypeHasName "<xsl:value-of select="@class"/>"^^xsd:string ;
.	
	</xsl:template>
<!--...............................................................................................-->	

<!-- ============================================================================================================================================== -->
<!-- ============================================================================================================================================== -->
<!--
___________________________________________________________________________________________________
 Business Motivation Model (BMM)
___________________________________________________________________________________________________-->
	<xsl:template match="MODEL" mode="BMM">
transfer:<xsl:value-of select="@id"/>
  rdf:type emo:BusinessMotivationMetaModel ;
  rdfs:label "<xsl:value-of select="@name"/>"^^xsd:string ;
  emo:objectTypeHasID "<xsl:value-of select="@id"/>"^^xsd:string ;
  emo:objectTypeHasName "<xsl:value-of select="@name"/>"^^xsd:string ;
  emo:objectTypeHasDescription "<xsl:value-of select="@modeltype"/>"^^xsd:string ;
.	
		<xsl:variable name="modelId" select="@id">
  </xsl:variable>
		<xsl:apply-templates select=".//INSTANCE[@class='Goal']" mode="Goal"/>
		<xsl:apply-templates select=".//INSTANCE[@class='Learning Goal']" mode="LearningGoal"/>
	</xsl:template>
<!--...............................................................................................-->	

<!--
___________________________________________________________________________________________________
 Goal
___________________________________________________________________________________________________-->
	<xsl:template match="INSTANCE" mode="Goal">
transfer:<xsl:value-of select="@id"/>
  rdf:type bmm:Goal ;
  rdfs:label "<xsl:value-of select="@name"/>"^^xsd:string ;
  emo:objectTypeHasName "<xsl:value-of select="@class"/>"^^xsd:string ;
.	
	</xsl:template>
<!--...............................................................................................-->	

<!--
___________________________________________________________________________________________________
 Learning Goal
___________________________________________________________________________________________________-->
	<xsl:template match="INSTANCE" mode="LearningGoal">
transfer:<xsl:value-of select="@id"/>
  rdf:type emo:LearningGoal ;
  rdfs:label "<xsl:value-of select="@name"/>"^^xsd:string ;
  emo:objectTypeHasName "<xsl:value-of select="@class"/>"^^xsd:string ;
.	
	</xsl:template>
<!--...............................................................................................-->	

<!-- ============================================================================================================================================== -->
<!-- ============================================================================================================================================== -->
<!--
___________________________________________________________________________________________________
 Document and Knowledge model (DKM)
___________________________________________________________________________________________________-->
	<xsl:template match="MODEL" mode="DKM">
transfer:<xsl:value-of select="@id"/>
  rdf:type emo:DocumentAndKnowledgeMetaModel ;
  rdfs:label "<xsl:value-of select="@name"/>"^^xsd:string ;
  emo:objectTypeHasID "<xsl:value-of select="@id"/>"^^xsd:string ;
  emo:objectTypeHasName "<xsl:value-of select="@name"/>"^^xsd:string ;
  emo:objectTypeHasDescription "<xsl:value-of select="@modeltype"/>"^^xsd:string ;
.	
		<xsl:variable name="modelId" select="@id">
  </xsl:variable>
		<xsl:apply-templates select=".//INSTANCE[@class='Document']" mode="Document"/>
		<xsl:apply-templates select=".//INSTANCE[@class='Group']" mode="DocumentGroup"/>
	</xsl:template>
<!--...............................................................................................-->	

<!--
___________________________________________________________________________________________________
 Document
___________________________________________________________________________________________________-->
	<xsl:template match="INSTANCE" mode="Document">
transfer:<xsl:value-of select="@id"/>
  rdf:type dkm:Document ;
  rdfs:label "<xsl:value-of select="@name"/>"^^xsd:string ;
  emo:objectTypeHasName "<xsl:value-of select="@class"/>"^^xsd:string ;
  <xsl:call-template name="addInModelConnection">
        <xsl:with-param name="objectProperty" select="'dkm:d_ConstructIsInsideD_Container'"/>
        <xsl:with-param name="targetInstanceClass" select="'Group'"/>
    </xsl:call-template>.	
	</xsl:template>
<!--...............................................................................................-->	

<!--
___________________________________________________________________________________________________
 Document Group
___________________________________________________________________________________________________-->
	<xsl:template match="INSTANCE" mode="DocumentGroup">
transfer:<xsl:value-of select="@id"/>
  rdf:type dkm:D_Container ;
  rdfs:label "<xsl:value-of select="@name"/>"^^xsd:string ;
  emo:objectTypeHasName "<xsl:value-of select="@class"/>"^^xsd:string ;
.
	</xsl:template>
<!--...............................................................................................-->	

<!-- ============================================================================================================================================== -->
<!-- ============================================================================================================================================== -->
<!--
___________________________________________________________________________________________________
 Organizational structure (OMM)
___________________________________________________________________________________________________-->
	<xsl:template match="MODEL" mode="OMM">
transfer:<xsl:value-of select="@id"/>
  rdf:type emo:OrganisationMetaModel ;
  rdfs:label "<xsl:value-of select="@name"/>"^^xsd:string ;
  emo:objectTypeHasID "<xsl:value-of select="@id"/>"^^xsd:string ;
  emo:objectTypeHasName "<xsl:value-of select="@name"/>"^^xsd:string ;
  emo:objectTypeHasDescription "<xsl:value-of select="@modeltype"/>"^^xsd:string ;
.	
		<xsl:variable name="modelId" select="@id">
  </xsl:variable>
		<xsl:apply-templates select=".//INSTANCE[@class='Organizational unit']" mode="OrganizationalUnit"/>
		<xsl:apply-templates select=".//INSTANCE[@class='Role']" mode="Role"/>
		<xsl:apply-templates select=".//INSTANCE[@class='Performer']" mode="Performer"/>
	</xsl:template>
<!--...............................................................................................-->	
<!--
___________________________________________________________________________________________________
 Organizational unit
___________________________________________________________________________________________________-->
	<xsl:template match="INSTANCE" mode="OrganizationalUnit">
transfer:<xsl:value-of select="@id"/>
  rdf:type omm:OrganisationalUnit ;
  rdfs:label "<xsl:value-of select="@name"/>"^^xsd:string ;
  emo:objectTypeHasName "<xsl:value-of select="@class"/>"^^xsd:string ;
  <xsl:call-template name="addInModelConnection">
        <xsl:with-param name="objectProperty" select="'omm:organisationalUnitIsSubordinatedToOrganisationalUnit'"/>
        <xsl:with-param name="targetInstanceClass" select="'Organizational unit'"/>
    </xsl:call-template>.
	</xsl:template>
<!--...............................................................................................-->	
<!--
___________________________________________________________________________________________________
 Role
___________________________________________________________________________________________________-->
	<xsl:template match="INSTANCE" mode="Role">
transfer:<xsl:value-of select="@id"/>
  rdf:type omm:Role ;
  rdfs:label "<xsl:value-of select="@name"/>"^^xsd:string ;
  emo:objectTypeHasName "<xsl:value-of select="@class"/>"^^xsd:string ;
  <xsl:call-template name="addInModelConnection">
        <xsl:with-param name="objectProperty" select="'lpd:roleIsCastedByOrgUnit'"/>
        <xsl:with-param name="targetInstanceClass" select="'Organizational unit'"/>
    </xsl:call-template>.
	</xsl:template>
<!--...............................................................................................-->	
<!--
___________________________________________________________________________________________________
 Performer
___________________________________________________________________________________________________-->
	<xsl:template match="INSTANCE" mode="Performer">
transfer:<xsl:value-of select="@id"/>
  rdf:type omm:Performer ;
  rdfs:label "<xsl:value-of select="@name"/>"^^xsd:string ;
  emo:objectTypeHasName "<xsl:value-of select="@class"/>"^^xsd:string ;
  <xsl:call-template name="addInModelConnection">
        <xsl:with-param name="objectProperty" select="'omm:performerHasRole'"/>
        <xsl:with-param name="targetInstanceClass" select="'Role'"/>
    </xsl:call-template>.
	</xsl:template>
<!--...............................................................................................-->	
</xsl:stylesheet>