# Radix-2^2 SDF fft

verilog로 radix-2^2 구조를 갖는 16-point fft를 구현해보았다.
- fixed piont 연산을 위해 round, saturation 모듈 구현
- butterfly 모듈 구현
- shift buffer로 delay 모듈 구현
- butterfly control 신호 중요
- ROM에 twiddle factor 저장
- 허수 연산을 위한 multiply 모듈 구현
- bitwidth, depth(fft point) parameter로 설정하여 수정 편리
- 출력 순서 정렬 안해서 fft 출력 순서가 bitreverse 순으로 나옴

![image](https://github.com/user-attachments/assets/00c6ff1d-0757-42dc-84cf-85288fa654f4)

[이미지출처]https://images.app.goo.gl/Mxp6ep1sDgNAF4wh9



behavior waveform

![image](https://github.com/user-attachments/assets/96b1d4fb-13fc-47d2-9ee2-c4737992fabd)

정답지와 비교

![image](https://github.com/user-attachments/assets/fbd586f6-15ae-4979-813b-7de6fa12399e)
