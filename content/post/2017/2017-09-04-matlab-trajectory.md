---
date: "2017-09-04T14:55:01+09:00"
title: "MATLABでスラローム軌道生成"
categories:
  - "作品紹介"
tags:
  - "マイクロマウス"
  - "MATLAB"
  - "制御"
thumbnail: "icon.png"
---

## 概要

[前回](/posts/2017-09-03-pattern-of-turn/)の記事ではマイクロマウスのターンの紹介をしました。今回は、そのカーブの軌道の生成方法を紹介したいと思います。

<!--more-->

## 生成される軌道

### 角速度はサインカーブで変化

台形加速でも十分ですが、よりよいカーブを求めてサイン加速に挑戦しました。

台形加速の1次関数は、傾きが変化したときに加速度がステップ状に変化します。しかし、三角関数ならば無限回微分可能なので、ステップ変化は一切ありません。

{{< postfig src="sine-curve.png" title="角速度と角度の変化" >}}

### カーブ前後の直線

僕が採用しているパターンの区切りは区画の中央または、壁の中央です。パターンによっては前後対称になっておらず、カーブだけで軌道を埋めることができないので、前後に調整用の直線を入れています。

また、柱にぶつからないように、前後の直線でカーブの位置を調整しています。

下の図では青線がパターンの区切りからカーブ開始位置までの直線、赤線がカーブ、黄線がカーブ終了位置からパターンの区切りまでの直線です。

### #0 探索90°

{{< postfig src="00-0-90.png" title="探索90°" >}}

### #1 最短45°

{{< postfig src="01-0-45.png" title="45°" >}}

### #2 最短90°

{{< postfig src="02-0-90.png" title="90°" >}}

### #3 最短135°

{{< postfig src="03-0-135.png" title="135°" >}}

### #4 最短180°

{{< postfig src="04-0-180.png" title="180°" >}}

### #5 最短斜め90度

{{< postfig src="05-45-135.png" title="斜め90" >}}

### #6 ロング斜め90°

{{< postfig src="06-45-135.png" title="ロング斜め90°" >}}

### #7 ロング135°

{{< postfig src="07-0-135.png" title="ロング135°" >}}

### #8 ロング180°

{{< postfig src="08-0-180.png" title="ロング180°" >}}

### #9 斜めロング180°

{{< postfig src="09-45-225.png" title="斜めロング180°" >}}

### #10 特殊斜め180°

{{< postfig src="10-45-225.png" title="特殊斜め180°" >}}


## MATLABコード

解説は割愛するので、コード中のコメントをご覧ください。

生成されるデータは、前後の直線を含まないカーブ部分の[x,y,θ]の列(1mm間隔)です。

~~~m
%% file: slalom.m
% author: kerikun11
% date: 2017.09.04

clear;
%% 区画の大きさを定義 [mm]
seg_full = 180;
seg_half = seg_full / 2;

%% パターンを選択
% adv_straight: カーブ前の直線部分の長さ [mm]
% pos_start: 始点位置 [x; y; theta]
% pos_start: 終点位置 [x; y; theta]
switch 0
    case 0 % #0 search 90
        adv_straight = 5;
        pos_start = [0; 0; 0];
        pos_end = [seg_half; seg_half; pi/2];
    case 1 % #1 最短 45
        adv_straight = 0;
        pos_start = [0; 0; 0];
        pos_end = [seg_full; seg_half; pi/4];
    case 2 % #2 最短 90
        adv_straight = 10;
        pos_start = [0; 0; 0];
        pos_end = [seg_full; seg_full; pi/2];
    case 3 % #3 最短 135
        adv_straight = 20;
        pos_start = [0; 0; 0];
        pos_end = [seg_half; seg_full; 3/4*pi];
    case 4 % #4 最短 180
        adv_straight = 20;
        pos_start = [0; 0; 0];
        pos_end = [0; seg_full; pi];
    case 5 % #5 最短 斜め 90
        adv_straight = 5;
        pos_start = [0; 0; pi/4];
        pos_end = [0; seg_full; 3/4*pi];
    case 6 % #6 最短 ロング 斜め 90
        adv_straight = 0;
        pos_start = [0; 0; pi/4];
        pos_end = [0; seg_full * 2; 3/4*pi];
    case 7 % #7 最短 ロング 135
        adv_straight = 0;
        pos_start = [0; 0; 0];
        pos_end = [seg_half; seg_full * 2; 3/4*pi];
    case 8 % #8 最短 ロング 180
        adv_straight = 0;
        pos_start = [0; 0; 0];
        pos_end = [seg_half; seg_full * 2; pi];
end

%% 設定情報
% 点列の間隔 [mm]
dx = 1.0;
% 角速度と角加速度を設定
omega_dot = 150 * pi;
omega_max = 5 * pi;

%% 必要情報の算出
% スタートポジションの同時変換行列を生成
Rot_start = [cos(pos_start(3)),-sin(pos_start(3)),0;sin(pos_start(3)),cos(pos_start(3)),0;0,0,1];
% オフセットを消去し目標位置を算出
pos_target = Rot_start \ (pos_end - pos_start) - [adv_straight; 0; 0];
% 正弦波加速の1周期の時間を算出
T = omega_max / omega_dot * pi;
[t, theta] = ode45(@(t, theta) omega_max * sin(pi*t/T)^2, [0 T], 0); %#ok<ASGLU>

%% 積分結果が目標角度を超えているかどうかで条件分岐
if pos_target(3) < theta(end)
    %% 積分結果が目標角度を超えている場合
    % 終点角度が目標角度になるようなスケーリング係数
    theta_gain = sqrt(pos_target(3) / theta(end));
    % 時間をスケーリング
    T = T * theta_gain;
    % 数値積分で軌道を生成
    [t, x] = ode45(@(t, x) cos(theta_gain * ((omega_max*t)/2 - (T*omega_max*sin((2*pi*t)/T))/(4*pi))), [0 T], 0);
    [t, y] = ode45(@(t, x) sin(theta_gain * ((omega_max*t)/2 - (T*omega_max*sin((2*pi*t)/T))/(4*pi))), [0 T], 0);
    % 終点位置が目標位置になるように並進速度を算出
    syms v;
    v = double(solve((pos_target(2)-v*y(end))*cos(pos_target(3))==(pos_target(1)-v*x(end))*sin(pos_target(3)), v));
    %% 軌道の表示、生成
    dt = dx/v;
    x_end = x(end)*v; y_end = y(end)*v;
    % 角速度の配列を生成
    figure();
    omega = omega_max * sin(pi*[0:dt:T]/T).^2;
    subplot(6, 1, 1); hold off;
    plot(0:dt:T, omega, '.', 'MarkerSize', 12); grid on;
    % 角度の配列を生成
    [t, theta] = ode45(@(t, theta) theta_gain * omega_max * sin(pi*t/T)^2, [0:dt:T], 0);
    subplot(6, 1, 2); hold off;
    plot(t, theta, '.', 'MarkerSize', 12); grid on;
    % 位置の配列を生成
    [t, x] = ode45(@(t, x) v * cos(theta_gain * ((omega_max*t)/2 - (T*omega_max*sin((2*pi*t)/T))/(4*pi))), [0:dt:T], 0);
    [t, y] = ode45(@(t, y) v * sin(theta_gain * ((omega_max*t)/2 - (T*omega_max*sin((2*pi*t)/T))/(4*pi))), [0:dt:T], 0);
    subplot(6, 1, [3 6]); hold off;
    plot(x, y, '.', 'MarkerSize', 12); grid on;
    % 出力データを生成
    pos = [x, y, theta];
    pos = [pos; x_end, y_end, pos_target(3)];
else
    %% 積分結果が目標角度に満たない場合
    % 角速度が一定の時間を設けて目標角度になるように調節する
    % 角速度 加速時間
    T1 = T / 2;
    % 角速度 一定時間
    T2 = T1 + (pos_target(3) - theta(end)) / omega_max;
    % 角速度 減速時間
    T3 = T2 + T / 2;
    % 数値積分で軌道を生成
    [t, x1] = ode45(@(t, x1) cos((omega_max*t)/2 - (T*omega_max*sin((2*pi*t)/T))/(4*pi)), [0 T/2], 0);
    [t, x2] = ode45(@(t, x2) cos((omega_max*T/2)/2 - (T*omega_max*sin((2*pi*T/2)/T))/(4*pi) + omega_max*(t-T1)), [T1 T2], x1(end));
    [t, x3] = ode45(@(t, x3) cos(omega_max*(T2-T1) + (omega_max*(t-T2+T1))/2 - (T*omega_max*sin((2*pi*(t-T2+T1))/T))/(4*pi)), [T2 T3], x2(end));
    [t, y1] = ode45(@(t, y1) sin((omega_max*t)/2 - (T*omega_max*sin((2*pi*t)/T))/(4*pi)), [0 T/2], 0);
    [t, y2] = ode45(@(t, y2) sin((omega_max*T/2)/2 - (T*omega_max*sin((2*pi*T/2)/T))/(4*pi) + omega_max*(t-T1)), [T1 T2], y1(end));
    [t, y3] = ode45(@(t, y3) sin(omega_max*(T2-T1) + (omega_max*(t-T2+T1))/2 - (T*omega_max*sin((2*pi*(t-T2+T1))/T))/(4*pi)), [T2 T3], y2(end));
    % 終点位置が目標位置になるように並進速度を算出
    syms v;
    v = double(solve((pos_target(2)-v*y3(end))*cos(pos_target(3))==(pos_target(1)-v*x3(end))*sin(pos_target(3)), v));
    %% 軌道の表示、生成
    dt = dx/v;
    t1 = 0:dt:T1;
    t2 = t1(end):dt:T2;
    t3 = t2(end):dt:T3;
    x1_end = x1(end)*v; x2_end = x2(end)*v; x3_end = x3(end)*v;
    y1_end = x1(end)*v; y2_end = y2(end)*v; y3_end = y3(end)*v;
    % 角速度の配列を生成
    figure();
    subplot(6, 1, 1); hold off;
    plot(t1, omega_max * sin(pi*t1/T).^2, '.', 'MarkerSize', 12); grid on; hold on;
    plot(t2, omega_max+t2*0, '.', 'MarkerSize', 12); grid on; hold on;
    plot(t3, omega_max * sin(pi*(t3-T2+T1)/T).^2, '.', 'MarkerSize', 12); grid on; hold on;
    % 角度の配列を生成
    subplot(6, 1, 2); hold off;
    theta1 = (omega_max*t1)/2 - (T*omega_max*sin((2*pi*t1)/T))/(4*pi);
    theta2 = (omega_max*T/2)/2 - (T*omega_max*sin((2*pi*T/2)/T))/(4*pi) + omega_max*(t2-T1);
    theta3 = omega_max*(T2-T1) + (omega_max*(t3-T2+T1))/2 - (T*omega_max*sin((2*pi*(t3-T2+T1))/T))/(4*pi);
    plot(t1, theta1, '.', 'MarkerSize', 12); grid on; hold on;
    plot(t2, theta2, '.', 'MarkerSize', 12); grid on; hold on;
    plot(t3, theta3, '.', 'MarkerSize', 12); grid on; hold on;
    % 位置の配列を生成
    [t, x1] = ode45(@(t, x1) v*cos((omega_max*t)/2 - (T*omega_max*sin((2*pi*t)/T))/(4*pi)), t1, 0);
    [t, x2] = ode45(@(t, x2) v*cos((omega_max*T/2)/2 - (T*omega_max*sin((2*pi*T/2)/T))/(4*pi) + omega_max*(t-T1)), t2, x1(end));
    [t, x3] = ode45(@(t, x3) v*cos(omega_max*(T2-T1) + (omega_max*(t-T2+T1))/2 - (T*omega_max*sin((2*pi*(t-T2+T1))/T))/(4*pi)), t3, x2(end));
    [t, y1] = ode45(@(t, y1) v*sin((omega_max*t)/2 - (T*omega_max*sin((2*pi*t)/T))/(4*pi)), t1, 0);
    [t, y2] = ode45(@(t, y2) v*sin((omega_max*T/2)/2 - (T*omega_max*sin((2*pi*T/2)/T))/(4*pi) + omega_max*(t-T1)), t2, y1(end));
    [t, y3] = ode45(@(t, y3) v*sin(omega_max*(T2-T1) + (omega_max*(t-T2+T1))/2 - (T*omega_max*sin((2*pi*(t-T2+T1))/T))/(4*pi)), t3, y2(end));
    subplot(6, 1, [3 6]); hold off;
    plot(x1, y1, '.', 'MarkerSize', 12); hold on; grid on;
    plot(x2, y2, '.', 'MarkerSize', 12); hold on; grid on;
    plot(x3, y3, '.', 'MarkerSize', 12); hold on; grid on;

    % 出力データを生成
    pos = [x1, y1, theta1'; x2(2:end), y2(2:end), theta2(2:end)'; x3(2:end), y3(2:end), theta3(2:end)'];
    pos = [pos; x3_end, y3_end, omega_max*(T2-T1) + (omega_max*(T3-T2+T1))/2 - (T*omega_max*sin((2*pi*(T3-T2+T1))/T))/(4*pi)];
end

%% 出力情報
format long;
% 並進速度
velocity = v;
% 求めた軌跡の配列の長さ
length = size(pos, 1);
% カーブ終了から終点位置までの直線部分の長さを算出
extra_straight = max([(pos_target(2)-pos(end, 2)) / sin(pos_target(3)),(pos_target(1)-pos(end, 1)) / cos(pos_target(3))]);

%% 上で生成したグラフ(カーブのみ)を装飾
subplot(6,1,1);
title(sprintf('$$ \\dot{\\omega}_{max}: %.0f\\pi,\\ \\omega_{max}: %.0f\\pi $$', omega_dot/pi, omega_max/pi), 'Interpreter','latex', 'FontSize', 12);
xlabel('t', 'Interpreter','latex', 'FontSize', 12);
ylabel('\omega', 'FontSize', 12);
xlim([0, dt*length]);
subplot(6,1,2);
title(sprintf('$$ \\theta_{end}: %.2f\\pi $$', pos_target(3)/pi), 'Interpreter','latex', 'FontSize', 12);
xlabel('t', 'Interpreter','latex', 'FontSize', 12);
ylabel('\theta', 'FontSize', 12);
xlim([0, dt*length]);
subplot(6,1,[3 6]);
title(sprintf('$$ v_{max}: %.3f $$', v), 'Interpreter','latex', 'FontSize', 12);
xlabel('x', 'Interpreter','latex', 'FontSize', 12);
ylabel('y', 'Interpreter','latex', 'FontSize', 12);
axis equal;
xlim([min(pos(:,1)), max(pos(:,1))]);
ylim([min(pos(:,2)), max(pos(:,2))]);

%% スタート位置と直線部分を加味してプロット
pos_disp = pos_start + Rot_start * [adv_straight; 0; 0]+ Rot_start * pos';
figure(); hold on;
plot([0 pos_disp(1,1)], [0, pos_disp(2,1)], 'LineWidth', 4);
plot(pos_disp(1,:), pos_disp(2,:), 'LineWidth', 4);
plot([pos_disp(1,end), pos_disp(1,end)+extra_straight*cos(pos_end(3))], [pos_disp(2,end), pos_disp(2,end)+extra_straight*sin(pos_end(3))], 'LineWidth', 4);
axis equal;
xlim([round(min(pos_disp(1,:))/seg_half)*seg_half, ceil(max(pos_disp(1,:)-1)/seg_half)*seg_half]);
ylim([round(min(pos_disp(2,:))/seg_half)*seg_half, ceil(max(pos_disp(2,:)-1)/seg_half)*seg_half]);
xticks(-5*seg_half:seg_half/6:5*seg_half);
yticks(-5*seg_half:seg_half/6:5*seg_half);
grid on;

%% 情報の出力
% x[mm], y[mm], theta[rad]のCSV形式で保存
dlmwrite('data.csv', pos, 'precision', '%.10f');
length
velocity
extra_straight
~~~

## まとめ

マウスの制御方法は人によってかなり違うので、この方法が役に立つかわかりませんが、参考にどうぞ。

もっといい方法を知っている方がいましたら、是非教えてくださいね！
