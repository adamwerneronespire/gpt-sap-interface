> **Goal**: Enable GitHub Copilot / Codex to generate highly reliable, modern ABAP code for SAP S/4HANA 2023 (108).  
> Follow every rule below and *double‑check* your work before providing the final answer.

---

## 1 ▪ Repository Standards
| Topic | Guideline |
|-------|-----------|
| **Commit messages** | English, max 72 chars subject, imperative mood (e.g. “Add VAT rounding helper”). |
| **File comments** | Write all Markdown & code comments in **English** so they remain translatable. Other languages are allowed only in ABAP object translations. |
| **Formatting** | Keep Markdown and ABAP code tidy & lint‑free. |
| **Tests** |*Self‑Review Checklist* and run abaplint. Abaplint conditions and details consulted in the *abaplint* section below |

---

## 2 ▪ System Compatibility
* Target release: **SAP S/4HANA 2023 (108)**.  
* Always prefer the *latest* ABAP features that are available in this release, e.g.:
  * `DATA(...)` / `INLINE DATA` declarations  
  * `SWITCH …` / `VALUE …` expressions  
  * `NEW` constructor operators  
  * `RAISE EXCEPTION TYPE … MESSAGE …`  
* When using CDS, AMDP, RAP etc. ensure the syntax fits 2023 SP level.

---

## 3 ▪ Function Module Parameterization
1. **Discover parameters**  
   Use SE80 or [se80.co.uk](https://www.se80.co.uk/) to list *all* parameters and their types.
2. **Match types exactly**  
   Align caller variables with the FM signature (use LIKE REF TO / TYPE TABLE OF … where applicable).
3. **Check mandatory inputs**  
   If a required parameter is missing, obtain or derive it before calling the FM.
4. **Handle `SY‑SUBRC`**  
   ```abap
   CALL FUNCTION 'BAPI_SOMETHING'
     EXPORTING
       iv_key = lv_key
     IMPORTING
       ev_data = ls_data
     EXCEPTIONS
       OTHERS  = 4.
   IF sy-subrc <> 0.
     "→ Convert FM messages to the application log or raise an exception
   ENDIF.
   ```

---

## 4 ▪ ABAP Coding Practices
* **Syntax** – must compile with *no* warnings. Validate via ATC or `Ctrl+F2`.
* **Error handling** – never ignore `sy‑subrc`; raise meaningful exceptions.
* **Indexes** – guard every numeric index with `LINES( )` checks.
* **Loop index pattern** – avoid `LOOP ... INDEX`; define `lv_index` at loop start and set it to `sy-tabix`.
* **Object references** – verify `IS BOUND` before dereferencing.
* **Variable scope** – declare locals at the **start** of each routine.
* **Type and data placement** – declare `TYPE` and `DATA` statements at the top of each method, form, or function unless using inline declarations.
* **Structure** – keep methods ≤ 80 LOC; extract helpers if needed.
* Always populate hash tables using `INSERT`.

---

## 5 ▪ Commenting Guidelines
* Be **concise & clear** – one sentence per intent.
* Add extended explanations only for **non‑obvious** logic or business rules.
* Do **not** number comment steps (maintainability).
* Mark TODOs with `TODO:` so they are searchable.

---

## 6 ▪ Self‑Review Checklist (run *before* finishing)
1. **Syntax check** – run *Program → Check → Syntax* (`Ctrl+F2`).
2. **ATC run** – ensure zero *priority 1–3* findings.
3. **Consistency** – variable names follow naming convention (e.g. `lv_`, `lt_`, `ls_`).
4. **Null safety** – every reference is verified with `IS BOUND`.
5. **Performance** – no nested selects, use `FOR ALL ENTRIES` or CDS where suitable.
6. **Internationalisation** – wrap UI text in `TEXT‑###` elements.
7. **Unit of work** – COMMIT/ROLLBACK handled in a controlled layer.
8. **Link validation** – add any SAP Help or SE80 links consulted in the *References* section below.

---

## 7 ▪ Validation & References
After coding, paste the links you used for API or syntax verification here, for example:

* [ABAP CLEANER – `VALUE` Rule](https://github.com/SAP/abap-cleaner/tree/main/docs/rules/)
* [BAPI_SOMETHING Parameters – se80.co.uk](https://www.se80.co.uk/sapfunctionmodules/?name=BAPI_SOMETHING)
* [ABAP-SDK-for-Azure – abapGit samples](https://github.com/microsoft/ABAP-SDK-for-Azure) – use these XML examples to generate abapGit files and as validation references

---

## 8 ▪ abaplint
* Run `abaplint` only when a commit modifies more than 100 lines.
* If 100 lines or fewer change, you may skip `abaplint` but mention this in the final response.
* When more than 100 lines change, run `abaplint` and report the outcome. Before run, you have to clone the repo: https://github.com/abaplint/abaplint.git. If it is not run, explicitly state this.

