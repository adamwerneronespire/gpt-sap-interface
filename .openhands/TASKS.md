# Task List

1. ✅ Elemezni a repót és meghatározni a szükséges CDS nézeteket az ABAP kódellenőrzés támogatásához
Megvannak a meglévő nézetek: Z_CDS_Sources, Z_DDIC_Tables, Z_DDIC_Fields, Z_FM_Parameters és a Z_META_ALL service. Hiányzik a Z_FunctionModules és Z_BADI_Definition forrás. Új hasznos nézetek: Data Elements, Domains, Domain Values, Repository Objects (TADIR), Programs (TRDIR), Message Texts (T100).
2. ✅ Létrehozni a hiányzó Z_FunctionModules CDS nézetet (ddls + baseinfo + xml)

3. ✅ Létrehozni a Z_BADI_Definition CDS nézetet (ddls + baseinfo + xml)

4. ✅ Létrehozni Z_Data_Elements CDS nézetet (DD04L)

5. ✅ Létrehozni Z_Domains CDS nézetet (DD01L) és asszociációt Z_Domain_Values felé

6. ✅ Létrehozni Z_Domain_Values CDS nézetet (DD07V)

7. ✅ Létrehozni Z_TADIR_Objects CDS nézetet (TADIR)

8. ✅ Létrehozni Z_Programs CDS nézetet (TRDIR)

9. ✅ Létrehozni Z_Message_Texts CDS nézetet (T100)

10. ✅ Frissíteni a Z_META_ALL service definition-t az új entitások exponálásával

11. 🔄 Commitálni a változtatásokat a main ágon


