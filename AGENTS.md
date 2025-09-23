# Repository Guidelines

## Architecture
- Use the **MVVM pattern** for new features.
- Place views in `Views/`, models in `Models/`, and view models in `ViewModels/`.
- Views show UI only; business logic must be in the ViewModel.

## Language
- All code, comments, commit messages, and test names must be in **English**.

## Commits
- Do not auto-commit. Stage and commit only when explicitly requested by the developer.
- Use the **Conventional Commits** style:
  - `feat:` for features.
  - `fix:` for bug fixes.
  - `refactor:`, `test:`, `docs:` as needed.
- Commit message format:
- feat(Tasks): add ability to mark task as completed
- fix(Notes): correct date formatting in note detail view

## Project Structure
- Keep folder organization: `Views/`, `ViewModels/`, `Models/`, `Services/`, `Utils/`, `Tests/`.
