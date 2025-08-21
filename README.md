# gpt-sap-interface
GPT SAP Interface

Our goal list to creat an ODATA end point to get data like table, table fields, BAPIs FMs for given S4Hana system.

These entities use only SAP repository tables. The associations make “get all (per object)” possible via $expand.
1) CDS catalogue
@EndUserText.label: 'Active CDS sources (name + SQL view)'
@AbapCatalog.sqlViewName: 'ZV_CDS_SRC'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity Z_CDS_Sources
  as select from ddddlsrc
{
  key ddlname,
      sqlviewname,
      package_name,
      created_by,
      created_on
}
where state = 'A';
(ABAP CDS exposes an SQL view per CDS via @AbapCatalog.sqlViewName; this is also what you’ll see over OData.) SAP Help Portal
2) DDIC tables → fields (expandable)
@EndUserText.label: 'DDIC tables (active)'
@AbapCatalog.sqlViewName: 'ZV_DDIC_TBL'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity Z_DDIC_Tables
  as select from dd02l
  association [0..*] to Z_DDIC_Fields as _Fields
    on $projection.tabname = _Fields.tabname
{
  key tabname,
      tabclass,
      as4local,
      as4date,
      ddtext,
      _Fields                             // expose assoc for $expand
}
where as4local = 'A';
@EndUserText.label: 'DDIC fields'
@AbapCatalog.sqlViewName: 'ZV_DDIC_FLD'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity Z_DDIC_Fields
  as select from dd03l
{
  key tabname,
  key fieldname,
      position,
      datatype,
      leng,
      decimals,
      as4local
}
where as4local = 'A';
(Associations must be exposed in the element list to be available to consumers for $expand.) SAP Help Portal
3) Function modules → parameters (expandable)
@EndUserText.label: 'Function modules (active)'
@AbapCatalog.sqlViewName: 'ZV_FM_META'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity Z_FunctionModules
  as select from tfdir
    left outer join enlfdir on enlfdir.funcname = tfdir.funcname
    left outer join tftit   on tftit.funcname   = tfdir.funcname
  association [0..*] to Z_FM_Parameters as _Parameters
    on $projection.funcname = _Parameters.funcname
{
  key tfdir.funcname            as funcname,
      tfdir.fmode               as fmode,
      tfdir.utask               as utask,
      enlfdir.active            as active,
      enlfdir.generated         as generated,
      tftit.stext               as stext,
      _Parameters
}
where enlfdir.active = 'X';
@EndUserText.label: 'Function module parameters (active)'
@AbapCatalog.sqlViewName: 'ZV_FM_PARAM'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity Z_FM_Parameters
  as select from fupararef
{
  key funcname,
  key parameter,
  key paramtype,     // I/E/C/T
      structure,
      defaultval,
      optional,
      reference,
      r3state
}
where r3state = 'A';
(TFDIR/ENLFDIR are the FM directories; parameters come from FUPARAREF.) SAP CommunitySE80
4) BAdI catalogue
@EndUserText.label: 'BAdI definitions (classic)'
@AbapCatalog.sqlViewName: 'ZV_BADI_DEF'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity Z_BADI_Definition
  as select from sxc_exit
    left outer join sxc_attr on sxc_attr.exit_name = sxc_exit.exit_name
{
  key sxc_exit.exit_name,
      sxc_exit.interface,
      sxc_attr.devclass,
      sxc_attr.active,
      sxc_attr.description
};
(SXC_EXIT/SXC_ATTR are core BAdI metadata tables.) SAP Community
B) One OData V4 “everything” endpoint
1) Service Definition (SRVD)
@EndUserText.label: 'All metadata service (CDS/DDIC/FM/BAdI)'
define service Z_META_ALL {
  expose Z_CDS_Sources     as CdsSources;
  expose Z_DDIC_Tables     as DdicTables;
  expose Z_DDIC_Fields     as DdicFields;
  expose Z_FunctionModules as FunctionModules;
  expose Z_FM_Parameters   as FunctionModuleParameters;
  expose Z_BADI_Definition as BadiDefinitions;
}
 