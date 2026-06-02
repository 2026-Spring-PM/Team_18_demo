# 🌾 Team 18 데모 게임 실행 가이드

이 문서대로 따라 하면 **Team 18 데모 게임**을 실행할 수 있습니다.
본인 OS( **Windows · macOS · Linux** )를 찾아 **위에서부터 순서대로** 진행하세요.

> 📩 **잘 안 되면 아래로 연락 주세요.**
> - felixhuh@snu.ac.kr
> - justin1404@snu.ac.kr

각 OS는 **공통 준비 단계**를 거친 뒤, **마지막 실행 단계에 2개의 방법이 있습니다. 둘 중 하나만** 선택하세요.

- **방법 1 ⭐ (추천)** — 진짜 OS 창으로 띄우기 (빠름)
- **방법 2 🌐 (최후의 안전한 방법)** — Docker + 브라우저로 띄우기 (어디서나 됨)

> 👉 **방법 1을 먼저** 해보고, 막히면 **방법 2**로 하세요.

> ⚠️ 한 번에 **하나의 게임만** 실행하세요. 여러 데모를 동시에 켜면 포트(6080)가 겹쳐 에러납니다.

---

# 💻 Windows

> 🔻 **1 → 2 → 3단계는 공통**, 마지막 **4단계에 2개의 방법이 있습니다 — 하나만 선택**.

### 1단계 — WSL2 설치
1. 시작 메뉴 → **PowerShell** 우클릭 → **"관리자 권한으로 실행"**
2. 설치돼 있는지 확인:
   ```powershell
   wsl -l -v
   ```
   - Ubuntu 등 배포판이 보이면 → **이미 설치됨, 2단계로**
   - 아무것도 안 나오면 → 아래로 설치 후 **재부팅**:
     ```powershell
     wsl --install -d Ubuntu-22.04
     ```
     재부팅 후 Ubuntu 창이 뜨면 사용자 이름·비밀번호를 정합니다.

### 2단계 — Docker Desktop 설치
- 작업표시줄에 **고래 아이콘**이 있고 running이면 → **이미 설치됨, 3단계로**
- 없으면:
  1. https://www.docker.com/products/docker-desktop/ 에서 Windows용 설치
  2. Docker Desktop 실행 → **Settings(톱니바퀴)**
     - **General** → "Use the WSL 2 based engine" 체크
     - **Resources → WSL Integration** → 본인 Ubuntu 배포판 스위치 켜기
  3. **Apply & Restart**

### 3단계 — 게임 파일 받기
시작 메뉴 → **Ubuntu** 실행 후:
```bash
sudo apt update && sudo apt install -y git
git clone https://github.com/2026-Spring-PM/Team_18_demo.git
cd Team_18_demo
```

### 🔀 4단계 — 실행 〔2개의 방법 존재 · 하나만 선택〕

#### └─ 방법 1 ⭐ WSLg로 진짜 Windows 창 (추천)
Ubuntu 터미널(`Team_18_demo` 폴더 안)에서:
```bash
docker pull --platform linux/amd64 chwoong/team_00_project:0.1.0
bash scripts/run_wslg.sh
```
→ 잠시 후 **게임 창이 바로 뜹니다. 끝!**
(Windows 10이거나 창이 안 뜨면 → 방법 2)

#### └─ 방법 2 🌐 Docker + 브라우저 (최후의 방법)
1. 실행:
   ```bash
   docker pull --platform linux/amd64 chwoong/team_00_project:0.1.0
   bash scripts/run.sh
   ```
   첫 실행 30초~1분. 로그가 올라오면 정상이고 **이 터미널은 끄지 마세요.**
2. Windows 브라우저(크롬/엣지)에서 접속 → **Connect** 클릭:
   ```
   http://localhost:6080/vnc.html
   ```

---

# 🍎 macOS  (Apple Silicon · M1/M2/M3/M4)

> 🔻 **1단계는 공통**, 마지막 **2단계에 2개의 방법이 있습니다 — 하나만 선택**.

### 1단계 — 게임 파일 받기
터미널 실행( **⌘ + Space** → "터미널" ) 후:
```bash
git clone https://github.com/2026-Spring-PM/Team_18_demo.git
cd Team_18_demo
```
(`git` 입력 시 "개발자 도구 설치" 팝업이 뜨면 **설치** 클릭)

### 🔀 2단계 — 실행 〔2개의 방법 존재 · 하나만 선택〕

#### └─ 방법 1 ⭐ Docker 없이 진짜 Mac 창 (추천)
1. **Homebrew 설치** (이미 있으면 건너뛰기) — https://brew.sh 의 한 줄 명령을 터미널에 붙여넣기
2. **SFML 설치** (한 번만):
   ```bash
   brew install sfml@2
   ```
3. **실행:**
   ```bash
   bash scripts/run_native.sh
   ```
   → 진짜 Mac 게임 창이 뜹니다. **끝!** (에러나면 → 방법 2)

#### └─ 방법 2 🌐 Docker + 브라우저 (최후의 방법)
1. **Docker Desktop 설치** (없으면) — https://www.docker.com/products/docker-desktop/ 에서 **Apple Silicon** 버전 설치 후 실행 (메뉴바에 고래 아이콘이 뜰 때까지 기다리기)
2. **실행:**
   ```bash
   docker pull --platform linux/amd64 chwoong/team_00_project:0.1.0
   bash scripts/run.sh
   ```
   첫 실행 30초~1분. **터미널은 끄지 마세요.**
3. **브라우저**(크롬/사파리)에서 접속 → **Connect**:
   ```
   http://localhost:6080/vnc.html
   ```

> 💡 Apple Silicon에서 방법 2는 amd64 에뮬레이션이라 약간 느립니다(정상). 그래서 방법 1이 더 빠릅니다.

---

# 🐧 Linux  (Ubuntu / Debian 계열 · x86_64)

> 🔻 **1단계는 공통**, 마지막 **2단계에 2개의 방법이 있습니다 — 하나만 선택**.

### 1단계 — 게임 파일 받기
터미널에서:
```bash
sudo apt update && sudo apt install -y git
git clone https://github.com/2026-Spring-PM/Team_18_demo.git
cd Team_18_demo
```

### 🔀 2단계 — 실행 〔2개의 방법 존재 · 하나만 선택〕

#### └─ 방법 1 ⭐ Docker 없이 진짜 창 (추천)
1. **SFML 라이브러리 설치:**
   ```bash
   sudo apt install -y libsfml-graphics2.6 libsfml-window2.6 libsfml-system2.6
   ```
2. **실행:**
   ```bash
   bash scripts/run_native.sh
   ```
   → 진짜 게임 창이 뜹니다. **끝!** (라이브러리 에러나면 → 방법 2)

#### └─ 방법 2 🌐 Docker + 브라우저 (최후의 방법)
1. **Docker 설치** (없으면):
   ```bash
   sudo apt install -y docker.io
   sudo systemctl enable --now docker
   sudo usermod -aG docker $USER
   ```
   마지막 줄 후 **로그아웃 → 다시 로그인** (그룹 적용). 이후 `docker ps`가 에러 없이 되면 OK.
2. **실행:**
   ```bash
   docker pull --platform linux/amd64 chwoong/team_00_project:0.1.0
   bash scripts/run.sh
   ```
   첫 실행 30초~1분. **터미널은 끄지 마세요.**
3. **브라우저**에서 접속 → **Connect**:
   ```
   http://localhost:6080/vnc.html
   ```

---

# 🛠 문제 해결 (공통)

| 증상 | 해결 |
|---|---|
| 브라우저 페이지가 안 열림 | 게임 실행 터미널이 켜져 있는지 확인 → 로그가 다 올라온 뒤 1~2초 기다렸다 새로고침 |
| Connect 후 까만 화면 | 잠깐 기다렸다 브라우저 새로고침 |
| `port is already allocated` / `Bind for ...:6080 failed` | 6080을 쓰는 컨테이너가 이미 있음 → 아래로 정리 후 재실행 |
| Mac/Windows Docker 에러 | Docker Desktop이 실행 중(고래 아이콘 running)인지 먼저 확인 |
| 방법 1(native)에서 SFML 에러 | 설치 명령 다시 확인하거나, 그냥 **방법 2(브라우저)**로 가면 확실함 |

**포트 충돌 정리 명령:**
```bash
docker ps
docker rm -f farm-sim-team18-container
```
