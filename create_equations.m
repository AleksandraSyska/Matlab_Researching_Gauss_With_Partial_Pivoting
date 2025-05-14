function [M, w] = create_equations(C, c)
    % CREATE_EQUATIONS Tworzy rzeczywisty układ blokowy z zespolonego układu równań
    %
    % Wejście:
    %   C - macierz zespolona n x n (współczynniki układu)
    %   c - wektor zespolony n x 1 (prawa strona układu)
    %
    % Wyjście:
    %   M - macierz rzeczywista 2n x 2n w postaci blokowej
    %   w - wektor rzeczywisty 2n x 1
    %
    % Opis:
    %   Funkcja przekształca układ równań zespolonych C*z = c na równoważny
    %   układ rzeczywisty M*x = w poprzez rozdzielenie części rzeczywistych
    %   i urojonych. Jest to pierwszy krok w metodzie rozwiązywania
    %   układów równań liniowych z zespolonymi współczynnikami.
    %
    % Przykład użycia:
    %   C = [1+2i, 3-1i; 2+0i, 4+2i];
    %   c = [5+1i; 6-2i];
    %   [M, w] = create_equations(C, c);

    A = real(C);  % Część rzeczywista macierzy C
    B = imag(C);  % Część urojona macierzy C
    M = [A, -B;   % Macierz blokowa [A -B]
         B,  A];  %                [B  A]
    
    a = real(c);  % Część rzeczywista wektora c
    b = imag(c);  % Część urojona wektora c
    w = [a; b];   % Połączony wektor [a; b]
end