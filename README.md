# MLB 선수 데이터 분석 프로그램

## 프로젝트 소개
MLB 선수 데이터에 대한 Bash 기반 분석 프로그램입니다.

## 사용법

```bash
./EDA.sh 2024_MLB_Player_Stats.csv
```

## 메뉴 구성
[Menu]
1. Search player by name in MLB data
2. List top 5 players by SLG value
3. Analyze the team stats - average age and total home runs
4. Compare players in different age groups
5. Search the players who meet specific statistical conditions
6. Generate a perfomance report
7. Quit

## 주요 기능
1. ```search_player_by_name```<br>
사용자 입력 이름을 기준으로 해당 선수의 통계 정보를 검색 및 출력합니다.

2. ```list_top_5_players_by_slg_value```<br>
타석 수가 502 이상인 선수 중 SLG(장타율)가 가장 높은 상위 5인을 출력합니다.

3. ```analyze_the_team_stats```<br>
특정 팀명을 입력받아 해당 팀의 평균 나이, 홈런 수, 타점 합계를 계산하여 출력합니다.

4. ```compare_players_in_different_age_groups```<br>
나이에 따라 세 그룹으로 나누어 SLG 기준 상위 5명을 출력합니다.

5. ```search_the_players_who_meet_specific_statistical_conditions```<br>
홈런 수와 타율에 대한 최소 기준을 입력받아 해당 조건을 만족하는 선수를 검색하여 출력합니다.

6. ```generate_a_perfomance_report```<br>
특정 팀을 선택하여 해당 팀 선수들의 선수명, HR, RBI, BA, OBP, OPS를 포맷에 맞게 정리한 리포트를 출력합니다.

7. ```quit```<br>
프로그램을 종료합니다.