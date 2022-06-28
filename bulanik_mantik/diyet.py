import numpy as np
import skfuzzy as fuzz
import skfuzzy.membership as mf
import matplotlib.pyplot as plt


def bulanik_mantik(index, yas):
    x_index = np.arange(0, 45, 1)
    x_yas = np.arange(0, 71, 1)
    x_kalori = np.arange(65, 135, 1)

    index_zayif = mf.trimf(x_index, [0, 0, 20])
    index_normal = mf.trimf(x_index, [17, 21.5, 26])
    index_kilolu = mf.trimf(x_index, [23.5, 27.5, 31.5])
    index_obez = mf.trimf(x_index, [28.5, 45, 45])

    yas_ergen = mf.trimf(x_yas, [0, 0, 25])
    yas_genc = mf.trimf(x_yas, [20, 30, 40])
    yas_orta_yasli = mf.trimf(x_yas, [35, 48, 60])
    yas_yasli = mf.trimf(x_yas, [55, 70, 70])

    kalori_cok_dusuk = mf.trimf(x_kalori, [65, 65, 82.5])
    kalori_dusuk = mf.trimf(x_kalori, [78.12, 86.88, 95.62])
    kalori_ortalama = mf.trimf(x_kalori, [91.25, 100, 108.8])
    kalori_yuksek = mf.trimf(x_kalori, [104.4, 113.2, 121.8])
    kalori_cok_yuksek = mf.trimf(x_kalori, [117.5, 135, 135])

    # fig, (ax0, ax1, ax2) = plt.subplots(nrows=3, figsize=(6, 10))
    #
    # ax0.plot(x_index, index_zayif, 'r', linewidth=2, label='Zayıf')
    # ax0.plot(x_index, index_normal, 'g', linewidth=2, label='Normal')
    # ax0.plot(x_index, index_kilolu, 'b', linewidth=2, label='Kilolu')
    # ax0.plot(x_index, index_obez, 'y', linewidth=2, label='Obez')
    #
    # ax0.set_title('Vücut İndeksi')
    # ax0.legend()
    #
    # ax1.plot(x_yas, yas_ergen, 'r', linewidth=2, label='Ergen')
    # ax1.plot(x_yas, yas_genc, 'g', linewidth=2, label='Genç')
    # ax1.plot(x_yas, yas_orta_yasli, 'b', linewidth=2, label='Orta Yaşlı')
    # ax1.plot(x_yas, yas_yasli, 'y', linewidth=2, label='Yaşlı')
    # ax1.set_title('Yaş')
    # ax1.legend()
    #
    # ax2.plot(x_kalori, kalori_cok_dusuk, 'r', linewidth=2, label='Çok Düşük')
    # ax2.plot(x_kalori, kalori_dusuk, 'g', linewidth=2, label='Düşük')
    # ax2.plot(x_kalori, kalori_ortalama, 'b', linewidth=2, label='Ortalama')
    # ax2.plot(x_kalori, kalori_yuksek, 'y', linewidth=2, label='Yüksek')
    # ax2.plot(x_kalori, kalori_cok_yuksek, 'c', linewidth=2, label='Çok Yüksek')
    # ax2.set_title('Kalori Oranı')
    # ax2.legend()
    #
    # plt.tight_layout()
    # plt.show()

    # Giriş Değerleri

    input_index = index
    input_yas = yas

    # Bulanıklaştırma

    index_zayif_son = fuzz.interp_membership(x_index, index_zayif, input_index)
    index_normal_son = fuzz.interp_membership(x_index, index_normal, input_index)
    index_kilolu_son = fuzz.interp_membership(x_index, index_kilolu, input_index)
    index_obez_son = fuzz.interp_membership(x_index, index_obez, input_index)

    yas_ergen_son = fuzz.interp_membership(x_yas, yas_ergen, input_yas)
    yas_genc_son = fuzz.interp_membership(x_yas, yas_genc, input_yas)
    yas_orta_yasli_son = fuzz.interp_membership(x_yas, yas_orta_yasli, input_yas)
    yas_yasli_son = fuzz.interp_membership(x_yas, yas_yasli, input_yas)

    # Kurallar

    rule1 = np.fmin(np.fmin(index_zayif_son, yas_ergen_son), kalori_cok_yuksek)
    rule = np.fmin(np.fmin(index_zayif_son, yas_ergen_son), kalori_cok_yuksek)
    rule2 = np.fmin(np.fmin(index_zayif_son, yas_genc_son), kalori_yuksek)
    rule3 = np.fmin(np.fmin(index_zayif_son, yas_orta_yasli_son), kalori_yuksek)
    rule4 = np.fmin(np.fmin(index_zayif_son, yas_yasli_son), kalori_yuksek)

    rule5 = np.fmin(np.fmin(index_normal_son, yas_ergen_son), kalori_yuksek)
    rule6 = np.fmin(np.fmin(index_normal_son, yas_genc_son), kalori_ortalama)
    rule7 = np.fmin(np.fmin(index_normal_son, yas_orta_yasli_son), kalori_ortalama)
    rule8 = np.fmin(np.fmin(index_normal_son, yas_yasli_son), kalori_ortalama)

    rule9 = np.fmin(np.fmin(index_kilolu_son, yas_ergen_son), kalori_ortalama)
    rule10 = np.fmin(np.fmin(index_kilolu_son, yas_genc_son), kalori_ortalama)
    rule11 = np.fmin(np.fmin(index_kilolu_son, yas_orta_yasli_son), kalori_dusuk)
    rule12 = np.fmin(np.fmin(index_kilolu_son, yas_yasli_son), kalori_dusuk)

    rule13 = np.fmin(np.fmin(index_obez_son, yas_ergen_son), kalori_dusuk)
    rule14 = np.fmin(np.fmin(index_obez_son, yas_genc_son), kalori_dusuk)
    rule15 = np.fmin(np.fmin(index_obez_son, yas_orta_yasli_son), kalori_dusuk)
    rule16 = np.fmin(np.fmin(index_obez_son, yas_yasli_son), kalori_cok_dusuk)
    rule17 = np.fmin(np.fmin(index_obez_son, yas_yasli_son), kalori_cok_dusuk)

    # Çıkışlar

    out_kalori_cok_yuksek = np.fmax(rule1, rule)
    #print(out_kalori_cok_yuksek)

    out_kalori_yuksek = np.fmax(rule2, np.fmax(rule3, np.fmax(rule4, rule5)))
    #print(out_kalori_yuksek)

    out_kalori_ortalama = np.fmax(rule6, np.fmax(rule7, np.fmax(rule8, np.fmax(rule9, rule10))))
    #print(out_kalori_ortalama)

    out_kalori_dusuk = np.fmax(rule11, np.fmax(rule12, np.fmax(rule13, np.fmax(rule14, rule15))))
    #print(out_kalori_dusuk)

    out_kalori_cok_dusuk = np.fmax(rule16, rule17)
    #print(out_kalori_cok_dusuk)

    # Tablo

    kalori = np.zeros_like(x_kalori)

    # fig, ax0 = plt.subplots(figsize=(7, 4))
    # ax0.fill_between(x_kalori, kalori, out_kalori_cok_yuksek, facecolor='r', alpha=0.7)
    # ax0.plot(x_kalori, kalori_cok_yuksek, 'r', linestyle='--')
    #
    # ax0.fill_between(x_kalori, kalori, out_kalori_yuksek, facecolor='g', alpha=0.7)
    # ax0.plot(x_kalori, kalori_yuksek, 'g', linestyle='--')
    #
    # ax0.fill_between(x_kalori, kalori, out_kalori_ortalama, facecolor='b', alpha=0.7)
    # ax0.plot(x_kalori, kalori_ortalama, 'b', linestyle='--')
    #
    # ax0.fill_between(x_kalori, kalori, out_kalori_dusuk, facecolor='y', alpha=0.7)
    # ax0.plot(x_kalori, kalori_dusuk, 'y', linestyle='--')
    #
    # ax0.fill_between(x_kalori, kalori, out_kalori_cok_dusuk, facecolor='c', alpha=0.7)
    # ax0.plot(x_kalori, kalori_cok_dusuk, 'c', linestyle='--')
    #
    # ax0.set_title('Fren Çıkışı')
    # plt.show()

    out_kalori = np.fmax(out_kalori_cok_yuksek, np.fmax(out_kalori_yuksek, np.fmax(out_kalori_ortalama,
                                                                                   np.fmax(out_kalori_dusuk,
                                                                                           out_kalori_cok_dusuk))))

    defuzzified = fuzz.defuzz(x_kalori, out_kalori, 'centroid')

    result = fuzz.interp_membership(x_kalori, out_kalori, defuzzified)

    return defuzzified
