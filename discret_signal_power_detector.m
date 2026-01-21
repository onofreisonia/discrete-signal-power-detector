% scenariu real
% se doreste implementarea unui "detector de putere medie" pentru un senzor
% sistemul primeste un semnal de intrare x[n] si calculeaza media patratelor 
% dintre esantionul curent si cel anterior
% aceasta este o operatie uzuala in prelucrarea semnalelor pentru a masura energia locala

% relatia matematica intrare-iesire:
% y[n] = 0.5 * (x[n])^2 + 0.5 * (x[n-1])^2

% obiective:
% 1-> implementarea sistemului in matlab 
% 2-> verificarea proprietatii de liniaritate 
% 3-> verificarea proprietatii de invarianta in timp
% 4-> reprezentarea grafica clara a semnalelor si a erorilor de verificare

clc; 
clear; 
close all;

%%generarea semnalelor de test
fs = 100;               % frecventa de esantionare
t = 0:1/fs:1;           % axa timpului (1 secunda)
n = 0:length(t)-1;      % axa indicilor discreti

% semnal 1: o sinusoidala
x1 = 2 * sin(2 * pi * 5 * t); 

% semnal 2: un semnal triunghiular 
x2 = 1.5 * sawtooth(2 * pi * 3 * t, 0.5);

%% implementarea si testarea liniaritatii
% un sistem l este liniar daca l(ax1 + bx2) = al(x1) + bl(x2)

%raspunsul la suma semnalelor 
x_sum = x1 + x2;
y_sum_input = sistem_putere(x_sum);

%suma raspunsurilor individuale 
y1 = sistem_putere(x1);
y2 = sistem_putere(x2);
y_sum_output = y1 + y2;

% calculul erorii de liniaritate
% daca sistemul este neliniar aceasta eroare va fi diferita de zero
eroare_liniaritate = y_sum_input - y_sum_output;
norma_lin = norm(eroare_liniaritate); 

%% implementarea si testarea invariantei in timp
% un sistem este invariant in timp daca o intarziere a intrarii
% produce exact aceeasi intarziere la iesire s(x[n-k]) = y[n-k]

k_delay = 20; % intarziere arbitrara de 20 esantioane

% aplicam sistemul pe un semnal intarziat la intrare
% cream x1 intarziat prin adaugarea de zerouri la inceput
x_delayed_input = [zeros(1, k_delay), x1(1:end-k_delay)];
y_response_delayed = sistem_putere(x_delayed_input);

% intarziem manual iesirea originala y1
y_delayed_manual = [zeros(1, k_delay), y1(1:end-k_delay)];

% calculul erorii de invarianta
% daca sistemul este invariant eroarea trebuie sa fie zero sau extrem de mica
eroare_invarianta = y_response_delayed - y_delayed_manual;
norma_inv = norm(eroare_invarianta);

%% reprezentarea grafica 
figure('name', 'analiza proprietati sistem putere', 'color', 'w', 'position', [150, 150, 900, 700]);
tl = tiledlayout(3, 1, 'tilespacing', 'compact', 'padding', 'compact');
title(tl, 'analiza sistemului de calcul al puterii y[n] = 0.5(x[n]^2 + x[n-1]^2)', 'fontsize', 14, 'fontweight', 'bold');

% grafic 1: demonstrarea neliniaritatii
nexttile;
plot(t, y_sum_input, 'b', 'linewidth', 1.5); hold on;
plot(t, y_sum_output, 'r--', 'linewidth', 1.5);
title(['test liniaritate eroare norma ' num2str(norma_lin, '%.2f')]);
ylabel('amplitudine');
legend('raspuns real s(x1+x2)', 'suprapunere s(x1)+s(x2)', 'location', 'northeast');
grid on;
text(0.02, max(y_sum_input)*0.9, '\leftarrow liniile nu se suprapun neliniar', 'color', 'k', 'backgroundcolor', 'w');

% grafic 2: vizualizarea erorii de liniaritate
nexttile;
area(t, eroare_liniaritate, 'facecolor', [0.85 0.33 0.1], 'edgecolor', 'none', 'facealpha', 0.6);
title('diferenta cauzata de termenul patratic x^2');
ylabel('eroare absoluta');
xlabel('timp secunde');
grid on;

% grafic 3: demonstrarea invariantei in timp
nexttile;
plot(t, y_response_delayed, 'g', 'linewidth', 2); hold on;
plot(t, y_delayed_manual, 'k:', 'linewidth', 2);
title(['test invarianta in timp eroare norma ' num2str(norma_inv, '%.2e')]);
ylabel('amplitudine');
xlabel('timp secunde');
legend('sistem intrare intarziata', 'iesire intarziata manual', 'location', 'northeast');
grid on;
%aici liniile se suprapun ---> sistemul este invariant

%% functia sistemului
function y = sistem_putere(x)
    % implementarea ecuatiei cu diferente
    % y[n] = 0.5 * x[n]^2 + 0.5 * x[n-1]^2
    
    len = length(x);
    y = zeros(1, len); % prealocare pentru viteza
    
    % bucla pentru implementarea elementului de memorie delay
    for n = 1:len
        val_curenta = x(n);
        
        if n > 1
            val_anterioara = x(n-1);
        else
            val_anterioara = 0; % conditie initiala
        end
        
        % calculul efectiv
        y(n) = 0.5 * (val_curenta^2) + 0.5 * (val_anterioara^2);
    end
end