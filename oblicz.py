import tkinter as tk

def oblicz():
    try:
        szer = float(entry_szer.get())
        pred = float(entry_pred.get())
        wsp  = float(entry_wsp.get())
        spalanie_h = float(entry_spalanie.get())
        masa_narzedzia = float(entry_masa.get())

        """
        Najpierw obliczamy realne spalanie godzinowe ciągnika, 
        biorąc pod uwagę opór i masę podłączonego sprzętu.
        Zakładamy, że każda tona masy narzędzia dorzuca 2.0 l/h do bazowego spalania.
        """
        dodatkowe_spalanie = (masa_narzedzia / 1000.0) * 2.0
        realne_spalanie_h = spalanie_h + dodatkowe_spalanie

        """
        Obliczanie wydajności powierzchniowej (ha/h)
        Zgodnie ze standardowym wzorem agrotechnicznym.
        """
        wydajnosc = (szer * pred * wsp) / 10
        
        """
        Obliczanie zużycia paliwa na hektar (l/ha)
        Spalanie godzinowe (uwzględniające masę) dzielimy przez wydajność.
        Jeżeli coś pójdzie nie tak z parametrami geometrycznymi, 
        można koncertowo zwalić dzielenie przez zero, dlatego sprawdzamy warunek.
        """
        if wydajnosc > 0:
            spalanie_ha = realne_spalanie_h / wydajnosc
            label_paliwo.config(text=f"Zużycie paliwa: {spalanie_ha:.2f} l/ha")
        else:
            label_paliwo.config(text="Zużycie paliwa: błąd (wydajność = 0)")

        label_wynik.config(text=f"Wydajność: {wydajnosc:.2f} ha/h")
        
    except ValueError:
        label_wynik.config(text="Błąd danych!")
        label_paliwo.config(text="Zużycie paliwa: ---")

root = tk.Tk()
root.title("Wydajność i Spalanie")

tk.Label(root, text="Szerokość [m]:").grid(row=0, column=0)
entry_szer = tk.Entry(root)
entry_szer.grid(row=0, column=1)

tk.Label(root, text="Prędkość [km/h]:").grid(row=1, column=0)
entry_pred = tk.Entry(root)
entry_pred.grid(row=1, column=1)

tk.Label(root, text="Współczynnik (0.6–0.8):").grid(row=2, column=0)
entry_wsp = tk.Entry(root)
entry_wsp.grid(row=2, column=1)

tk.Label(root, text="Zużycie paliwa (baza) [l/h]:").grid(row=3, column=0)
entry_spalanie = tk.Entry(root)
entry_spalanie.grid(row=3, column=1)

tk.Label(root, text="Masa narzędzia [kg]:").grid(row=4, column=0)
entry_masa = tk.Entry(root)
entry_masa.grid(row=4, column=1)

tk.Button(root, text="Oblicz", command=oblicz).grid(row=5, column=0, columnspan=2)

label_wynik = tk.Label(root, text="Wydajność: ---")
label_wynik.grid(row=6, column=0, columnspan=2)

label_paliwo = tk.Label(root, text="Zużycie paliwa: ---")
label_paliwo.grid(row=7, column=0, columnspan=2)

root.mainloop()