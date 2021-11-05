use std::env;

fn menu(smoothie: &str) -> Vec<&str>{
    match smoothie {
        "Classic" => vec!["a", "b", "c", "d"],
        _ => vec![]
    }
}

fn get_customizations<'a>(order_arr: &Vec<&'a str>, prefix: char) -> Vec<&'a str> {
    order_arr[1..]
        .iter()
        .filter(|x| x.chars().next().unwrap() == prefix)
        .map(|x| &x[1..])
        .collect::<Vec<&str>>()
}

fn ingredients (order: &str) -> String {
    let order_arr = order.split(",").collect::<Vec<&str>>();
    let smoothie = order_arr[0];
    let default_ingredients = menu(smoothie);
    let allergies = get_customizations(&order_arr, '-');
    let additions = get_customizations(&order_arr, '+');

    let mut result: Vec<&str> = default_ingredients
        .into_iter()
        .filter(|x| !allergies.contains(x))
        .chain(additions.into_iter())
        .collect();
    result.sort();
    result.join(",")
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let order = args[1].trim();
    println!("{}", ingredients(order));
}
