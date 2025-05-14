function z = solve_block_system(C, c)
    % SOLVE_BLOCK_SYSTEM Rozwiązuje zespolony układ liniowy C*z = c
    %
    % Wejście:
    %   C - macierz zespolona n x n (macierz współczynników)
    %   c - wektor zespolony n x 1 (wektor prawych stron)
    %
    % Wyjście:
    %   z - wektor zespolony n x 1 (rozwiązanie układu)
    %
    % Metoda:
    %   1. Przekształcenie układu zespolonego na rzeczywisty układ blokowy
    %   2. Rozwiązanie metodą eliminacji Gaussa z częściowym wyborem elementu głównego
    %
    % Przykład użycia:
    %   C = [2+1i, 1-0.5i; 1+0.5i, 3-1i];
    %   c = [1+0.5i; 2-1i];
    %   z = solve_block_system(C, c);

    % Sprawdzenie wymiarów macierzy
    if size(C,1) ~= size(C,2)
        error('solve_block_system:MatrixNotSquare', ...
              'Macierz C musi być kwadratowa');
    end
    if size(C,1) ~= length(c)
        error('solve_block_system:DimensionMismatch', ...
              'Wymiary C i c muszą być zgodne');
    end
    
    % Tworzenie macierzy blokowej i wektora
    [M, w] = create_equations(C, c);
    n_rows = size(M, 1);
    
    % Eliminacja Gaussa z częściowym wyborem elementu głównego
    for k = 1:n_rows-1
        % Częściowy wybór elementu głównego
        [max_val, max_row] = max(abs(M(k:n_rows, k)));
        max_row = max_row + k - 1;
        
        % Sprawdzenie czy macierz jest osobliwa
        if max_val < eps(class(M))
            disp('Macierz jest osobliwa lub prawie osobliwa');
        end

        
        % Zamiana wierszy jeśli potrzebna
        if max_row ~= k
            M([k, max_row], :) = M([max_row, k], :);
            w([k, max_row]) = w([max_row, k]);
        end
        
        % Eliminacja Gaussa (wektoryzowana)
        rows = k+1:n_rows;
        factors = M(rows, k) / M(k, k);
        M(rows, k:end) = M(rows, k:end) - factors * M(k, k:end);
        w(rows) = w(rows) - factors * w(k);
    end
    
    % Sprawdzenie ostatniego elementu głównego
    if max_val < eps(class(M))
            disp('Macierz jest osobliwa lub prawie osobliwa');
    end
    
    % Podstawienie wsteczne (w pełni wektoryzowane)
    result = zeros(n_rows, 1);
    for k = n_rows:-1:1
        result(k) = (w(k) - M(k, k+1:end) * result(k+1:end)) / M(k, k);
    end
    
    % Połączenie części rzeczywistych i urojonych
    n = n_rows / 2;
    z = result(1:n) + 1i * result(n+1:end);
end