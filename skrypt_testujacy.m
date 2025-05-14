% Skrypt testujący metodę rozwiązywania układów równań zespolonych
ERROR_THRESHOLD = 1e-16;

function display_system(C, c)
    fprintf('\nUkład równań:\n');
    [n, m] = size(C);
    
    for i = 1:n
        eq_str = '';
        first_term = true;  % Flaga, która pomoże obsłużyć pierwszy element równania
        
        for j = 1:m
            re = real(C(i,j));
            im = imag(C(i,j));
            
            % Obsługuje przypadek dla pierwszego elementu równania
            if first_term
                if re ~= 0 || im ~= 0  % Jeśli element nie jest zerowy
                    if im >= 0
                        eq_str = [eq_str num2str(re, '%.2f')];
                        if im ~= 0
                            eq_str = [eq_str '+' num2str(im, '%.2f') 'i'];
                        end
                    else
                        eq_str = [eq_str num2str(re, '%.2f')];
                        eq_str = [eq_str num2str(im, '%.2f') 'i'];  % Dla im < 0
                    end
                    eq_str = [eq_str '*z' num2str(j)];
                    first_term = false;  % Od teraz nie jesteśmy już przy pierwszym elemencie
                end
            else
                % Obsługuje pozostałe elementy równania
                if re > 0 || im > 0
                    eq_str = [eq_str ' + '];
                elseif re < 0 || im < 0
                    eq_str = [eq_str ' - '];
                    re = abs(re);
                    im = abs(im);
                end

                % Formatowanie liczby zespolonej
                if re ~= 0 && im ~= 0
                    eq_str = [eq_str '(' num2str(re, '%.2f') '+' num2str(im, '%.2f') 'i)*z' num2str(j)];
                elseif re ~= 0
                    eq_str = [eq_str num2str(re, '%.2f') '*z' num2str(j)];
                elseif im ~= 0
                    eq_str = [eq_str num2str(im, '%.2f') 'i*z' num2str(j)];
                end
            end
        end
        
        % Wyświetlenie równania z wynikiem
        fprintf('%s = %s\n', eq_str, num2str(c(i), '%.2f'));
    end
    fprintf('\n');
end



% Funkcja do wyświetlania błędów
function display_error(error_value, threshold)
    if abs(error_value) < threshold
        fprintf('Różnica w rozwiązaniach: 0 (mniej niż %.0e)\n\n', threshold);
    else
        fprintf('Różnica w rozwiązaniach: %e\n\n', error_value);
    end
end

%% Test 1: Duża macierz losowa 5x5
fprintf('=== TEST 1: Duża macierz losowa 5x5 (wydajność) ===\n');
n = 1000;
C = randn(n) + 1i*randn(n);
c = randn(n, 1) + 1i*randn(n, 1);

tic;
z_custom = solve_block_system(C, c);
time_custom = toc;

tic;
z_matlab = C \ c;
time_matlab = toc;

error = norm(z_custom - z_matlab);
fprintf('Czas mojej metody: %.4f s\n', time_custom);
fprintf('Czas MATLAB: %.4f s\n', time_matlab);
display_error(error, ERROR_THRESHOLD);

%% Test 2: Macierz dobrze uwarunkowana 3x3
fprintf('=== TEST 2: Macierz dobrze uwarunkowana 3x3 ===\n');
C = [3+2i, 0.5-0.3i, 0.4+0.1i;
     0.5+0.3i, 4-1i, 0.3+0.2i;
     0.4-0.1i, 0.3-0.2i, 5+3i];
c = [1.5+0.8i; 2.2-1.5i; 0.7+2.1i];

display_system(C, c);
    
z_custom = solve_block_system(C, c);
z_matlab = C \ c;

disp('Moje rozwiązanie:'); disp(z_custom.');
disp('Rozwiązanie MATLAB:'); disp(z_matlab.');
error = norm(z_custom - z_matlab);
display_error(error, ERROR_THRESHOLD);

%% Test 3: Macierz Hermitowska 4x4
fprintf('=== TEST 3: Macierz Hermitowska 4x4 ===\n');
C = [6, 1-2i, 2+1i, 0.5-0.5i;
     1+2i, 7, 3-2i, 1+1i;
     2-1i, 3+2i, 8, 0.5-1i;
     0.5+0.5i, 1-1i, 0.5+1i, 9];
c = [2+1i; 3-2i; 1+3i; 0.5-0.5i];

display_system(C, c);
    
z_custom = solve_block_system(C, c);
z_matlab = C \ c;

disp('Moje rozwiązanie:'); disp(z_custom.');
disp('Rozwiązanie MATLAB:'); disp(z_matlab.');
error = norm(z_custom - z_matlab);
display_error(error, ERROR_THRESHOLD);

%% Test 4: Macierz źle uwarunkowana 3x3
fprintf('=== TEST 4: Macierz źle uwarunkowana 3x3 ===\n');
C = [1+1i, 1+1.01i, 0.5+0.5i;
     1-1i, 1-1.01i, 0.5-0.5i;
     0.5+0.5i, 0.5+0.505i, 1+1i];
c = [2+2i; 2-2i; 1+1i];

display_system(C, c);
    
z_custom = solve_block_system(C, c);
z_matlab = C \ c;

disp('Moje rozwiązanie:'); disp(z_custom.');
disp('Rozwiązanie MATLAB:'); disp(z_matlab.');
error = norm(z_custom - z_matlab);
display_error(error, ERROR_THRESHOLD);

%% Test 5: Macierz prawie osobliwa 4x4
fprintf('=== TEST 5: Macierz prawie osobliwa 4x4 ===\n');
C = [1, 1i, 0, 0;
     1i, -1, 0, 0;
     0, 0, 1e-14, 1e-14i;
     0, 0, 1e-14i, -1e-14];
c = [1; 1i; 1e-14; 1e-14i];

display_system(C, c);
    
try
    z_custom = solve_block_system(C, c);
    z_matlab = C \ c;
    
    disp('Moje rozwiązanie:'); disp(z_custom.');
    disp('Rozwiązanie MATLAB:'); disp(z_matlab.');
    error = norm(z_custom - z_matlab);
    display_error(error, ERROR_THRESHOLD);
catch ME
    fprintf('Błąd: %s\n\n', ME.message);
end

%% Test 6: Macierz osobliwa 3x3
fprintf('=== TEST 6: Macierz osobliwa 3x3 ===\n');
C = [1, 1i, 1+1i;
     1, 1i, 1+1i;
     1, 1i, 1+1i];
c = [1; 1i; 1+1i];

display_system(C, c);
    
try
    z_custom = solve_block_system(C, c);
    z_matlab = C \ c;
    
    disp('Moje rozwiązanie:'); disp(z_custom.');
    disp('Rozwiązanie MATLAB:'); disp(z_matlab.');
    error = norm(z_custom - z_matlab);
    display_error(error, ERROR_THRESHOLD);
catch ME
    fprintf('Błąd: %s\n\n', ME.message);
end

%% Test 7: Macierz rzadka 5x5
fprintf('=== TEST 7: Macierz rzadka 5x5 ===\n');
C = [10+5i, 0, 0, 0, 0.1-0.2i;
     0, 10-5i, 0, 0, 0;
     0, 0, 10, 0, 0.3i;
     0, 0, 0, 10, 0;
     0.1+0.2i, 0, -0.3i, 0, 10];
c = [1+1i; 2-1i; 3+2i; 4-2i; 5+3i];

display_system(C, c);
    
tic;
z_custom = solve_block_system(C, c);
time_custom = toc;

tic;
z_matlab = C \ c;
time_matlab = toc;

disp('Moje rozwiązanie:'); disp(z_custom.');
disp('Rozwiązanie MATLAB:'); disp(z_matlab.');
error = norm(z_custom - z_matlab);
fprintf('Czas mojej metody: %.4f s\n', time_custom);
fprintf('Czas MATLAB: %.4f s\n', time_matlab);
display_error(error, ERROR_THRESHOLD);