# SHCO

파이썬 연습용 저장소입니다. 현재 구구단 출력 스크립트(`gugudan.py`) 하나가 들어 있습니다.

---

## Windows에서 로컬 개발 환경 만들기

아래 순서대로 따라 하면 내 PC에서 이 저장소를 받아 수정하고 다시 올릴 수 있습니다.

### 1. Git 설치

**방법 A — 설치 파일 (권장)**

1. https://git-scm.com/download/win 접속 → `64-bit Git for Windows Setup` 다운로드
2. 설치 마법사 실행. 대부분 기본값 그대로 두고 **Next**를 누르면 됩니다.
   신경 쓸 항목은 두 가지입니다.
   - *Adjusting your PATH environment* → **Git from the command line and also from 3rd-party software** (기본값)
   - *Configuring the line ending conversions* → **Checkout Windows-style, commit Unix-style line endings** (기본값)

**방법 B — 명령어 한 줄 (Windows 10/11)**

PowerShell을 열고:

```powershell
winget install --id Git.Git -e --source winget
```

설치 후 **PowerShell 창을 껐다가 다시 열어야** `git` 명령이 인식됩니다.

### 2. 설치 확인

```powershell
git --version
```

`git version 2.xx.x.windows.x` 처럼 나오면 정상입니다.

### 3. 최초 1회 사용자 정보 설정

커밋에 기록될 이름과 이메일입니다. GitHub 계정과 동일하게 맞추는 걸 권장합니다.

```powershell
git config --global user.name "본인 이름"
git config --global user.email "shcolife@gmail.com"
```

한글 파일명이 깨져 보이지 않도록 아래도 함께 설정해 두면 편합니다.

```powershell
git config --global core.quotepath false
```

### 4. 저장소 클론

작업할 폴더로 이동한 뒤 클론합니다. (예: `C:\dev`)

```powershell
mkdir C:\dev
cd C:\dev
git clone https://github.com/SHCO0531/SHCO.git
cd SHCO
```

처음 `git clone`이나 `git push`를 할 때 GitHub 로그인 창이 뜹니다.
브라우저로 로그인하면 이후에는 자격 증명이 저장되어 다시 묻지 않습니다.

> 비밀번호 입력을 요구받는 경우, GitHub는 계정 비밀번호를 더 이상 받지 않습니다.
> **Settings → Developer settings → Personal access tokens** 에서 토큰을 만들어
> 비밀번호 자리에 붙여 넣으세요.

### 5. 실행해 보기

파이썬이 없다면 https://www.python.org/downloads/windows/ 에서 설치합니다.
설치 화면 맨 아래 **Add python.exe to PATH** 체크를 꼭 켜세요.

```powershell
python gugudan.py
```

2단부터 9단까지 표 형태로 출력되면 성공입니다.

---

## 기본 작업 흐름

```powershell
# 1. 최신 내용 받아오기 (작업 시작 전 항상)
git pull origin main

# 2. 파일 수정 후 상태 확인
git status

# 3. 변경 사항 스테이징
git add gugudan.py        # 특정 파일만
git add .                 # 변경된 전체

# 4. 커밋 (메시지는 무엇을 왜 바꿨는지 적기)
git commit -m "구구단 출력 형식 정리"

# 5. GitHub로 올리기
git push origin main
```

### 브랜치를 쓸 때

```powershell
git switch -c my-feature      # 새 브랜치 만들며 이동
git switch main               # main으로 돌아가기
git branch                    # 브랜치 목록
git push -u origin my-feature # 새 브랜치를 원격에 처음 올릴 때
```

---

## 자주 쓰는 명령

| 명령 | 설명 |
| --- | --- |
| `git status` | 지금 무엇이 바뀌었는지 확인 |
| `git log --oneline` | 커밋 기록을 한 줄씩 보기 |
| `git diff` | 아직 add 하지 않은 변경 내용 보기 |
| `git diff --staged` | add 한 변경 내용 보기 |
| `git restore <파일>` | 수정한 파일을 마지막 커밋 상태로 되돌리기 |
| `git restore --staged <파일>` | `git add` 취소 (파일 내용은 유지) |
| `git remote -v` | 연결된 원격 저장소 주소 확인 |

---

## 문제가 생겼을 때

**`git`이 명령으로 인식되지 않습니다**
설치 후 터미널을 다시 열지 않아서입니다. PowerShell을 종료하고 새로 여세요.
그래도 안 되면 Git을 재설치하면서 PATH 옵션이 켜져 있는지 확인하세요.

**push할 때 `rejected ... fetch first` 오류**
원격에 내가 아직 받지 않은 커밋이 있다는 뜻입니다.

```powershell
git pull origin main
# 충돌이 났다면 파일을 열어 정리한 뒤
git add .
git commit
git push origin main
```

**한글이 깨져서 출력됩니다**
`gugudan.py`는 이미 UTF-8 출력 처리가 되어 있습니다.
그래도 깨진다면 PowerShell에서 `chcp 65001` 을 먼저 실행해 보세요.

**클론한 폴더 위치를 잊었습니다**

```powershell
cd C:\dev\SHCO
git remote -v
```
