//
//  MealModel.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/12.

import Foundation
import RealmSwift

/*
 Objectクラスのサブクラスとして定義する必要があるらしい。
 structじゃなくてclassなのは、"Objective-Cとの相互接続性が必要であればclassを使いましょう"とのこと。
 */
final class MealModel: Object {
    //primaryKeyは更新・追加の時に必要
    @Persisted(primaryKey: true) var id: ObjectId//勝手にidうまいことしてくれるぽい
    @Persisted var time: Date
    @Persisted var name: String
    @Persisted var calorie: Int
    @Persisted var protein: Int
    @Persisted var fat: Int
    @Persisted var carbohydrate: Int
}

final class FavoriteMealModel: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var calorie: Int
    @Persisted var protein: Int
    @Persisted var fat: Int
    @Persisted var carbohydrate: Int
}
