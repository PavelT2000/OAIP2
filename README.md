# OAIP2 - Object-Oriented Programming & Algorithms Lab Collection

## 📖 Overview
**OAIP2** is a structured repository of Delphi/Object Pascal projects developed as part of an advanced programming curriculum. It encompasses laboratory assignments, coursework, algorithmic implementations, and automated testing suites. The collection demonstrates practical application of recursion, data structures, mathematical computation, GUI development, and software engineering best practices.

## 🛠️ Tech Stack & Prerequisites
| Component | Details |
|-----------|---------|
| **Language** | Object Pascal (Delphi) |
| **IDE** | Embarcadero Delphi (Recommended: 10.3 Rio or newer) |
| **Testing** | DUnitX Framework (bundled) |
| **Documentation** | Microsoft Visio (`.vsd`/`.vsdx`), MS Word (`.doc`/`.docx`) |
| **Version Control** | Git (`.gitattributes` & `.aiignore` included) |

## 📁 Project Structure
The repository is organized into logical modules for academic and portfolio reference:

| Directory | Description |
|-----------|-------------|
| `HanoiTower` | Classic Tower of Hanoi recursive algorithm implementation |
| `Kursach` | Coursework project: mathematical expression evaluator & function plotter |
| `Lab4Recursion` | Recursion-focused labs: Permutations, QuickSort, HanoiTower (includes reports & flowcharts) |
| `Lab7` | Advanced lab assignments with multiple project variants & documentation |
| `LabWork1` | Foundational algorithms: Binary Search, Block Search, Neural/Pattern prototype |
| `MasPermutations` | Array permutation generator & analysis |
| `UNIT тесты` | DUnitX testing framework & custom unit test suite (`Tests.pas`) |
| `UPZN` | Custom generic/typed list implementation (`TypedList.pas`) |
| `Upozn` | CRUD-style data management system with storage, I/O, and dedicated testing module |

## 🚀 Getting Started

### Prerequisites
- Embarcadero Delphi IDE (compatible with `.dproj` project files)
- Microsoft Visio (optional, for viewing `.vsd`/`.vsdx` flowcharts)

### Building & Running
1. Open the repository root in Delphi.
2. Navigate to any module directory and open the corresponding `.dproj` or `.groupproj` file.
3. Press `F9` to compile and run, or `Ctrl+F9` to compile only.
4. **Coursework:** Open `Kursach\Kursach.dproj`
5. **Unit Tests:** Open `UNIT тесты\UNITTests.dpr`

> 💡 **Tip:** Project groups (`.groupproj`) can be used to manage multiple related projects simultaneously within the IDE.

## 🧪 Testing
The repository includes the **DUnitX** framework for automated unit testing.
- **Test Runner:** `UNIT тесты\UNITTests.dpr`
- **Test Suite:** `UNIT тесты\Tests.pas`
- Execute the test project to run all defined test cases. Results are output via the DUnitX console/GUI logger.

## 📚 Documentation & Reports
Each major module includes academic documentation:
- **Flowcharts:** Located in respective directories (`.vsd`, `.vsdx`)
- **Lab Reports:** `.doc` / `.docx` files detailing objectives, implementation, and results
- **Architecture/Design:** Visio diagrams illustrate algorithmic flow and system architecture

## 📝 Development Notes
- `__history` directories contain Delphi IDE auto-generated backups. These are excluded from active development and should be managed via `.gitignore`.
- `.identcache` and `.dproj.local` files are IDE-specific and environment-dependent.
- All source code is intended for educational purposes and demonstrates core OOP, algorithmic, and software testing principles.
- Russian-language documentation (`Отчёт.doc`, `UNIT тесты`) reflects the original academic context.

## 📄 License
This repository is provided for academic and educational use. Code and documentation may be referenced for learning purposes. Refer to individual project files for specific usage guidelines.

---
*Generated for OAIP2 Academic Project Collection*