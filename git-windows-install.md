# Git for Windows 설치 가이드

## 1. 다운로드

공식 사이트에서 설치 파일을 다운로드합니다.

- 공식 사이트: https://git-scm.com/download/win
- 최신 버전 자동 다운로드 링크 (64-bit): https://github.com/git-for-windows/git/releases/latest

## 2. 설치 과정

### 2.1 설치 파일 실행

다운로드한 `.exe` 파일을 실행합니다. (예: `Git-2.x.x-64-bit.exe`)

### 2.2 주요 설치 옵션

| 단계 | 권장 설정 |
|------|-----------|
| Select Components | 기본값 유지 |
| Default editor | Visual Studio Code 또는 Notepad++ 선택 |
| Initial branch name | `main` 선택 (Override the default branch name) |
| PATH environment | **Git from the command line and also from 3rd-party software** 선택 |
| SSH executable | Use bundled OpenSSH |
| HTTPS transport | Use the OpenSSL library |
| Line ending | **Checkout Windows-style, commit Unix-style** (기본값) |
| Terminal emulator | Use Windows' default console window |
| Default behavior of git pull | Default (fast-forward or merge) |
| Credential helper | Git Credential Manager |
| Extra options | Enable file system caching 체크 |

## 3. 설치 확인

설치 완료 후 명령 프롬프트(cmd) 또는 PowerShell을 열어 확인합니다.

```bash
git --version
```

출력 예시:
```
git version 2.x.x.windows.1
```

## 4. 초기 설정

Git을 처음 사용한다면 사용자 정보를 설정합니다.

```bash
git config --global user.name "이름"
git config --global user.email "이메일@example.com"
```

설정 확인:
```bash
git config --list
```

## 5. 기본 사용법

```bash
# 저장소 초기화
git init

# 파일 스테이징
git add .

# 커밋
git commit -m "커밋 메시지"

# 원격 저장소 연결
git remote add origin https://github.com/username/repository.git

# 푸시
git push -u origin main
```

## 6. 문제 해결

### 한글 파일명 깨짐
```bash
git config --global core.quotepath false
```

### SSL 인증서 오류
```bash
git config --global http.sslVerify false
```
> 주의: 보안상 필요한 경우에만 사용하세요.

### 줄바꿈 문제 (CRLF/LF)
```bash
git config --global core.autocrlf true
```
